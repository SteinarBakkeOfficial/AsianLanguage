import SwiftUI

/// Draft object-picture visual used to show what the character originally represented.
struct SymbolPictogramView: View {
    /// Corpus record id used for simple draft drawings.
    let recordID: String

    /// Fallback modern character shown when no draft drawing is available.
    let fallbackCharacter: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.opacity(0.08))
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green.opacity(0.35), lineWidth: 1)

            switch recordID {
            case "tree":
                tree
            case "day":
                sun
            case "moon":
                moon
            case "person", "big":
                person(armsWide: recordID == "big")
            case "small":
                smallDots
            case "mountain":
                mountain
            case "water":
                water
            case "fire":
                fire
            case "mouth":
                mouth
            case "eye":
                eye
            default:
                Text(fallbackCharacter)
                    .font(.system(size: 56, weight: .regular, design: .serif))
            }
        }
        .frame(height: 120)
        .accessibilityLabel("Original picture idea")
    }

    /// Draft tree pictogram with trunk and branches.
    private var tree: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.brown.opacity(0.8))
                .frame(width: 16, height: 72)
                .offset(y: 20)
            Circle()
                .fill(Color.green.opacity(0.30))
                .frame(width: 88, height: 70)
                .offset(y: -20)
            Path { path in
                path.move(to: CGPoint(x: 60, y: 96))
                path.addLine(to: CGPoint(x: 28, y: 46))
                path.move(to: CGPoint(x: 60, y: 88))
                path.addLine(to: CGPoint(x: 92, y: 42))
                path.move(to: CGPoint(x: 60, y: 82))
                path.addLine(to: CGPoint(x: 60, y: 34))
            }
            .stroke(Color.brown, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .frame(width: 120, height: 120)
        }
    }

    /// Draft sun pictogram.
    private var sun: some View {
        ZStack {
            Circle()
                .stroke(Color.orange, lineWidth: 6)
                .frame(width: 74, height: 74)
            Circle()
                .fill(Color.orange.opacity(0.35))
                .frame(width: 28, height: 28)
        }
    }

    /// Draft moon pictogram.
    private var moon: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.25))
                .frame(width: 78, height: 78)
            Circle()
                .fill(Color(.systemBackground))
                .frame(width: 70, height: 70)
                .offset(x: 20)
        }
    }

    /// Draft person pictogram.
    private func person(armsWide: Bool) -> some View {
        Path { path in
            path.addEllipse(in: CGRect(x: 52, y: 16, width: 24, height: 24))
            path.move(to: CGPoint(x: 64, y: 42))
            path.addLine(to: CGPoint(x: 64, y: 78))
            path.move(to: CGPoint(x: 64, y: 52))
            path.addLine(to: CGPoint(x: armsWide ? 26 : 46, y: 68))
            path.move(to: CGPoint(x: 64, y: 52))
            path.addLine(to: CGPoint(x: armsWide ? 102 : 82, y: 68))
            path.move(to: CGPoint(x: 64, y: 78))
            path.addLine(to: CGPoint(x: 42, y: 108))
            path.move(to: CGPoint(x: 64, y: 78))
            path.addLine(to: CGPoint(x: 86, y: 108))
        }
        .stroke(Color.primary, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
        .frame(width: 128, height: 120)
    }

    /// Draft smallness pictogram from separated small marks.
    private var smallDots: some View {
        HStack(spacing: 18) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.primary)
                    .frame(width: index == 1 ? 18 : 12, height: index == 1 ? 18 : 12)
            }
        }
    }

    /// Draft mountain pictogram.
    private var mountain: some View {
        Path { path in
            path.move(to: CGPoint(x: 10, y: 96))
            path.addLine(to: CGPoint(x: 38, y: 38))
            path.addLine(to: CGPoint(x: 62, y: 96))
            path.addLine(to: CGPoint(x: 82, y: 54))
            path.addLine(to: CGPoint(x: 118, y: 96))
        }
        .stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
        .frame(width: 128, height: 120)
    }

    /// Draft water pictogram.
    private var water: some View {
        VStack(spacing: 10) {
            ForEach(0..<3) { _ in
                WaveLine()
                    .stroke(Color.blue, lineWidth: 4)
                    .frame(width: 96, height: 16)
            }
        }
    }

    /// Draft fire pictogram.
    private var fire: some View {
        Path { path in
            path.move(to: CGPoint(x: 64, y: 104))
            path.addCurve(to: CGPoint(x: 42, y: 62), control1: CGPoint(x: 36, y: 84), control2: CGPoint(x: 34, y: 70))
            path.addCurve(to: CGPoint(x: 58, y: 18), control1: CGPoint(x: 52, y: 54), control2: CGPoint(x: 52, y: 34))
            path.addCurve(to: CGPoint(x: 88, y: 62), control1: CGPoint(x: 88, y: 40), control2: CGPoint(x: 96, y: 50))
            path.addCurve(to: CGPoint(x: 64, y: 104), control1: CGPoint(x: 104, y: 80), control2: CGPoint(x: 86, y: 102))
        }
        .fill(Color.orange.opacity(0.55))
        .overlay(
            Path { path in
                path.move(to: CGPoint(x: 64, y: 104))
                path.addCurve(to: CGPoint(x: 42, y: 62), control1: CGPoint(x: 36, y: 84), control2: CGPoint(x: 34, y: 70))
                path.addCurve(to: CGPoint(x: 58, y: 18), control1: CGPoint(x: 52, y: 54), control2: CGPoint(x: 52, y: 34))
                path.addCurve(to: CGPoint(x: 88, y: 62), control1: CGPoint(x: 88, y: 40), control2: CGPoint(x: 96, y: 50))
                path.addCurve(to: CGPoint(x: 64, y: 104), control1: CGPoint(x: 104, y: 80), control2: CGPoint(x: 86, y: 102))
            }
            .stroke(Color.orange, lineWidth: 5)
        )
        .frame(width: 128, height: 120)
    }

    /// Draft mouth pictogram.
    private var mouth: some View {
        RoundedRectangle(cornerRadius: 22)
            .stroke(Color.red.opacity(0.75), lineWidth: 7)
            .frame(width: 86, height: 52)
    }

    /// Draft eye pictogram.
    private var eye: some View {
        ZStack {
            Capsule()
                .stroke(Color.primary, lineWidth: 6)
                .frame(width: 96, height: 48)
            Circle()
                .fill(Color.primary)
                .frame(width: 20, height: 20)
        }
    }
}

/// Simple wave shape for draft water pictograms.
private struct WaveLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control1: CGPoint(x: rect.width * 0.25, y: rect.minY),
            control2: CGPoint(x: rect.width * 0.75, y: rect.maxY)
        )
        return path
    }
}
