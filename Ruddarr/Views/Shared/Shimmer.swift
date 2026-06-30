import SwiftUI

extension View {
    func shimmering(
        active: Bool = true,
        color: Color,
        highlight: Color? = nil,
        duration: Double = 1.12,
        pause: Double = 1,
        width: Double = 0.2
    ) -> some View {
        modifier(ShimmerModifier(
            active: active,
            color: color,
            highlight: highlight ?? color.mixed(with: .white, amount: 0.47),
            duration: duration,
            pause: pause,
            width: width
        )        )
    }
}

extension Color {
    func mixed(with other: Color, amount: Double) -> Color {
        let uiSelf = UIColor(self)
        let uiOther = UIColor(other)

        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        uiSelf.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiOther.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return Color(uiColor: UIColor(
            red: r1 + (r2 - r1) * amount,
            green: g1 + (g2 - g1) * amount,
            blue: b1 + (b2 - b1) * amount,
            alpha: a1 + (a2 - a1) * amount
        ))
    }
}

private struct ShimmerModifier: ViewModifier {
    let active: Bool
    let color: Color
    let highlight: Color
    let duration: Double
    let pause: Double
    let width: Double

    @ViewBuilder
    func body(content: Content) -> some View {
        if active {
            TimelineView(.animation) { context in
                let total = duration + pause
                let elapsed = context.date.timeIntervalSinceReferenceDate
                    .truncatingRemainder(dividingBy: total)
                let progress = min(elapsed / duration, 1)
                let center = -width + progress * (1 + 2 * width)

                content.foregroundStyle(
                    LinearGradient(
                        stops: [
                            .init(color: color, location: 0),
                            .init(color: highlight, location: 0.3),
                            .init(color: highlight, location: 0.7),
                            .init(color: color, location: 1),
                        ],
                        startPoint: UnitPoint(x: center - width, y: center - width),
                        endPoint: UnitPoint(x: center + width, y: center + width)
                    )
                )
            }
        } else {
            content.foregroundStyle(color)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        Text("Downloading")
            .font(.caption).fontWeight(.semibold).textCase(.uppercase)
            .shimmering(color: .purple)

        Spacer()
        Spacer()

        Text("Downloading")
            .font(.title).fontWeight(.bold)
            .shimmering(color: .blue)

        Spacer()
        Spacer()

        Text("Downloaded")
            .font(.caption).fontWeight(.semibold).textCase(.uppercase)
            .shimmering(active: false, color: .green)
    }
    .padding()
}
