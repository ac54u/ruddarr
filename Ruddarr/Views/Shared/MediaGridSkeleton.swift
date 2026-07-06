import SwiftUI

/// Skeleton placeholder grid matching MediaGrid dimensions.
/// Shows shimmering placeholder cards during initial data loading.
struct MediaGridSkeleton: View {
    let style: GridStyle
    let count: Int

    @Environment(\.deviceType) private var deviceType

    init(style: GridStyle = .posters, count: Int = 10) {
        self.style = style
        self.count = count
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(0 ..< count, id: \.self) { _ in
                skeletonCard
            }
        }
        .scenePadding(.horizontal)
    }

    @ViewBuilder
    var skeletonCard: some View {
        switch style {
        case .posters:
            RoundedRectangle(cornerRadius: 14)
                .fill(.systemFill)
                .aspectRatio(CGSize(width: 150, height: 225), contentMode: .fit)
                .shimmering(color: .systemFill)
        case .cards:
            HStack(alignment: .top, spacing: deviceType == .phone ? 10 : 14) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.systemFill)
                    .frame(width: posterWidth)
                    .aspectRatio(CGSize(width: 150, height: 225), contentMode: .fill)

                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.systemFill)
                        .frame(height: 16)
                        .frame(maxWidth: .infinity)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(.systemFill)
                        .frame(height: 12)
                        .frame(width: deviceType == .phone ? 140 : 180)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(.systemFill)
                        .frame(height: 12)
                        .frame(width: deviceType == .phone ? 100 : 140)

                    Spacer()
                }
                .padding(.vertical, deviceType == .phone ? 8 : 10)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.card)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shimmering(color: .systemFill)
        }
    }

    var columns: [GridItem] {
        switch style {
        case .posters: switch deviceType {
            case .phone: [GridItem(.adaptive(minimum: 100, maximum: 130), spacing: 12)]
            case .mac: [GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 20)]
            default: [GridItem(.adaptive(minimum: 145, maximum: 180), spacing: 20)]
        }
        case .cards: switch deviceType {
            case .phone: [GridItem(.adaptive(minimum: 300, maximum: 800), spacing: 12)]
            case .mac: [GridItem(.adaptive(minimum: 280, maximum: 450), spacing: 20)]
            default: [GridItem(.adaptive(minimum: 300, maximum: 450), spacing: 20)]
        }
        }
    }

    var spacing: CGFloat {
        deviceType == .phone ? 12 : 20
    }

    var posterWidth: CGFloat {
        deviceType == .phone ? 80 : 90
    }
}

#Preview("Posters") {
    ScrollView {
        MediaGridSkeleton(style: .posters)
    }
    .withAppState()
}

#Preview("Cards") {
    ScrollView {
        MediaGridSkeleton(style: .cards, count: 8)
    }
    .withAppState()
}
