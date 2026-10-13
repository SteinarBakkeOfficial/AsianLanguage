import Foundation
import Combine
import GoogleMobileAds
import UserMessagingPlatform
import UIKit

/// Owns consent, interstitial lifecycle, and the app-side frequency guard.
/// Change the event boundary here if a future release introduces another meaningful content visit.
@MainActor
final class MonetizationManager: NSObject, ObservableObject, FullScreenContentDelegate {
    private static let cooldown: TimeInterval = 5 * 60
    private static let lastPresentationKey = "scriptRoots.lastInterstitialPresentation"

    #if DEBUG
    private static let adUnitID = "ca-app-pub-3940256099942544/4411468910"
    #else
    private static let adUnitID = "ca-app-pub-4409095790258698/8880003420"
    #endif

    @Published private(set) var isPrivacyOptionsRequired = false

    private let defaults: UserDefaults
    private let sessionStartedAt: Date
    private var interstitial: InterstitialAd?
    private var isLoading = false
    private var hasStarted = false
    private var hasInitializedAds = false
    private var isPresenting = false
    private var viewedSymbolIDs = Set<String>()
    private var meaningfulSymbolCount = 0
    private var quickReviewAdvances = 0
    private var pendingEligibility = false
    private var pendingContinuation: (() -> Void)?

    nonisolated init(defaults: UserDefaults = .standard, sessionStartedAt: Date = Date()) {
        self.defaults = defaults
        self.sessionStartedAt = sessionStartedAt
        super.init()
    }

    /// Starts UMP once per process and only initializes ads after consent permits requests.
    func start() {
        guard !hasStarted else { return }
        hasStarted = true

        let parameters = RequestParameters()
        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) { [weak self] error in
            Task { @MainActor [weak self] in
                await self?.finishConsentUpdate(error: error)
            }
        }
    }

    /// Records one canonical Symbol Journey visit; repeated SwiftUI appearances for that ID are ignored.
    func recordMeaningfulSymbolView(_ symbolID: String) {
        guard viewedSymbolIDs.insert(symbolID).inserted else { return }
        meaningfulSymbolCount += 1
        if meaningfulSymbolCount >= 3 {
            pendingEligibility = true
        }
    }

    /// Presents only at a caller-defined natural transition; the continuation always runs.
    func presentIfEligible(then continuation: @escaping () -> Void) {
        guard pendingEligibility,
              !isPresenting,
              canPresentNow else {
            continuation()
            return
        }

        guard let interstitial, let presentingViewController = availablePresentingViewController() else {
            reloadAfterPresentation()
            continuation()
            return
        }

        pendingContinuation = continuation
        isPresenting = true
        interstitial.present(from: presentingViewController)
    }

    /// Allows every fifth non-final Quick Review card advance to consume pending eligibility.
    /// Quick Review itself does not create eligibility; the three-symbol activity threshold remains primary.
    func advanceQuickReview(then continuation: @escaping () -> Void) {
        quickReviewAdvances += 1
        guard quickReviewAdvances.isMultiple(of: 5) else {
            continuation()
            return
        }
        presentIfEligible(then: continuation)
    }

    /// Reopens Google's privacy choices form only when UMP says its entry point is required.
    func presentPrivacyChoices() {
        guard isPrivacyOptionsRequired, !isPresenting else { return }
        Task { @MainActor [weak self] in
            do {
                try await ConsentForm.presentPrivacyOptionsForm(from: nil)
            } catch {
                // Privacy failures fail open; the learning experience remains available.
            }
            self?.refreshPrivacyState()
            self?.startAdsIfAllowed()
        }
    }

    private var canPresentNow: Bool {
        guard ConsentInformation.shared.canRequestAds else { return false }
        let lastPresentation = defaults.object(forKey: Self.lastPresentationKey) as? Date
        let cooldownAnchor = max(sessionStartedAt, lastPresentation ?? .distantPast)
        return Date().timeIntervalSince(cooldownAnchor) >= Self.cooldown
    }

    private func finishConsentUpdate(error: Error?) async {
        refreshPrivacyState()
        do {
            try await ConsentForm.loadAndPresentIfRequired(from: nil)
        } catch {
            // Consent UI/network failures fail open; UMP may still retain a valid prior decision.
        }
        refreshPrivacyState()
        startAdsIfAllowed()
    }

    private func refreshPrivacyState() {
        isPrivacyOptionsRequired = ConsentInformation.shared.privacyOptionsRequirementStatus == .required
    }

    private func startAdsIfAllowed() {
        guard ConsentInformation.shared.canRequestAds, !hasInitializedAds else { return }
        hasInitializedAds = true
        MobileAds.shared.start { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.loadInterstitial()
            }
        }
    }

    private func loadInterstitial() async {
        guard !isLoading, interstitial == nil, ConsentInformation.shared.canRequestAds else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let loadedAd = try await InterstitialAd.load(with: Self.adUnitID, request: Request())
            loadedAd.fullScreenContentDelegate = self
            interstitial = loadedAd
        } catch {
            // Inventory/network failures fail open; the next allowed lifecycle callback retries.
        }
    }

    private func reloadAfterPresentation() {
        Task { @MainActor [weak self] in
            await self?.loadInterstitial()
        }
    }

    private func finishPendingTransition() {
        let continuation = pendingContinuation
        pendingContinuation = nil
        continuation?()
    }

    private func availablePresentingViewController() -> UIViewController? {
        let root = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: { $0.isKeyWindow })?.rootViewController
        guard let root, root.presentedViewController == nil else { return nil }
        var current = root
        while let presented = current.presentedViewController {
            current = presented
        }
        return current
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        isPresenting = true
        // A successful presentation consumes the current three-symbol activity cycle.
        viewedSymbolIDs.removeAll()
        meaningfulSymbolCount = 0
        pendingEligibility = false
        defaults.set(Date(), forKey: Self.lastPresentationKey)
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        interstitial = nil
        isPresenting = false
        finishPendingTransition()
        reloadAfterPresentation()
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        interstitial = nil
        isPresenting = false
        finishPendingTransition()
        reloadAfterPresentation()
    }
}
