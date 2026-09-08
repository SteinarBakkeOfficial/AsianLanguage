import SwiftUI
import UIKit
import UserNotifications

/// Settings screen for local preferences and offline app information.
struct SettingsView: View {
    /// Shared app dependencies used by the shell until real stores exist.
    let dependencies: AppDependencies

    /// Local state store used for focus language and reset controls.
    @ObservedObject private var userStateStore: LocalUserStateStore

    /// Controls the destructive learning-progress reset confirmation.
    @State private var isShowingResetConfirmation = false
    /// Controls the separate all-preferences reset confirmation.
    @State private var isShowingPreferencesResetConfirmation = false
    @AppStorage("reviewReminderEnabled") private var reviewReminderEnabled = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var reminderAuthorization: UNAuthorizationStatus = .notDetermined

    /// Creates Settings with observed access to local user state.
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _userStateStore = ObservedObject(wrappedValue: dependencies.userStateStore)
    }

    var body: some View {
        Form {
            Section("Display") {
                Picker("Appearance", selection: appearanceBinding) {
                    ForEach(AppearancePreference.allCases) { preference in
                        Text(preference.rawValue.capitalized).tag(preference)
                    }
                }
                Text("Choose Light or Dark appearance for the gallery shell.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Section("Offline content") {
                LabeledContent("Character library", value: "\(dependencies.installedSharedCharacterCount) available offline")
            }

            Section("Learning") {
                Button(reviewReminderEnabled ? "Turn off review reminder" : "Remind me to review") {
                    setReviewReminder(enabled: !reviewReminderEnabled)
                }
                Text(reviewReminderEnabled ? "A gentle daily reminder is scheduled on this device." : "Choose this when you want a gentle daily reminder to revisit saved characters.")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                if reminderAuthorization == .denied {
                    Text("Notifications are disabled for Script Roots in iPhone Settings.")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Button("Open Notification Settings") {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(url)
                    }
                }
            }

            Section("Data") {
                Button("Reset learning progress", role: .destructive) {
                    isShowingResetConfirmation = true
                }
                Button("Reset all preferences", role: .destructive) {
                    isShowingPreferencesResetConfirmation = true
                }
            }

            Section("About") {
                NavigationLink("About Script Roots") {
                    AboutMethodView(corpusCount: dependencies.installedSharedCharacterCount)
                }
                NavigationLink("Sources & Licenses") {
                    SourcesLicensesView(dependencies: dependencies)
                }
            }
        }
        .navigationTitle("Settings")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
        .task {
            refreshReminderState()
        }
        .onChange(of: scenePhase) { phase in
            guard phase == .active else { return }
            refreshReminderState()
        }
        .alert("Reset app progress?", isPresented: $isShowingResetConfirmation) {
            Button("Reset", role: .destructive) {
                userStateStore.resetLearningProgress()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears local progress, favorites, and review-later state on this device. It keeps display and focus preferences.")
        }
        .alert("Reset all preferences?", isPresented: $isShowingPreferencesResetConfirmation) {
            Button("Reset All", role: .destructive) {
                userStateStore.resetAllPreferences()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This resets learning progress and preferences, but does not delete the bundled corpus.")
        }
    }

    /// Binding for the small, intentionally limited appearance preference model.
    private var appearanceBinding: Binding<AppearancePreference> {
        Binding(
            get: { userStateStore.state.appearancePreference },
            set: { userStateStore.setAppearancePreference($0) }
        )
    }

    /// Requests permission only after an explicit user choice and never blocks the offline app.
    private func setReviewReminder(enabled: Bool) {
        let center = UNUserNotificationCenter.current()
        guard enabled else {
            reviewReminderEnabled = false
            center.removePendingNotificationRequests(withIdentifiers: ["script-roots-review-reminder"])
            refreshReminderState()
            return
        }

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                guard granted else {
                    reviewReminderEnabled = false
                    refreshReminderState()
                    return
                }
                let content = UNMutableNotificationContent()
                content.title = "Return to Script Roots"
                content.body = "A few quiet minutes with your saved characters."
                content.sound = .default
                let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 19, minute: 0), repeats: true)
                let request = UNNotificationRequest(identifier: "script-roots-review-reminder", content: content, trigger: trigger)
                center.add(request) { error in
                    DispatchQueue.main.async {
                        reviewReminderEnabled = error == nil
                        refreshReminderState()
                    }
                }
            }
        }
    }

    /// Keeps the visible toggle aligned with the system permission and pending request state.
    private func refreshReminderState() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            center.getPendingNotificationRequests { requests in
                let hasPendingReminder = requests.contains { $0.identifier == "script-roots-review-reminder" }
                DispatchQueue.main.async {
                    reminderAuthorization = settings.authorizationStatus
                    if settings.authorizationStatus == .denied || !hasPendingReminder {
                        reviewReminderEnabled = false
                    }
                }
            }
        }
    }
}

/// Lightweight feedback composer that uses the system share sheet and stores nothing remotely.
struct FeedbackView: View {
    @State private var feedback = ""
    @State private var isShowingShareSheet = false

    var body: some View {
        Form {
            Section("Your thoughts") {
                Text("Tell us what felt clear, confusing, or worth exploring next.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
                TextEditor(text: $feedback)
                    .frame(minHeight: 180)
            }
            Section {
                Button("Share Feedback") {
                    isShowingShareSheet = true
                }
                .disabled(feedback.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle("Send Feedback")
        .scrollContentBackground(.hidden)
        .background(AppColors.appBackground.ignoresSafeArea())
        .tint(AppColors.accentPrimary)
        .sheet(isPresented: $isShowingShareSheet) {
            FeedbackShareSheet(items: ["Script Roots feedback\n\n\(feedback)"])
        }
    }
}

/// Shares feedback through Mail, Messages, or another user-selected system destination.
private struct FeedbackShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
