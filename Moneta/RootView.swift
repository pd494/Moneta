import SwiftUI

struct RootView: View {
    // Interaction choices, expressed relative to the available travel.
    private let collapseThreshold: CGFloat = 0.15

    @State private var selectedSurface: Surface = .calendar
    @State private var collapsedHeight: CGFloat = 0
    @State private var expansion: CGFloat = 0
    @GestureState private var dragTranslation: CGFloat = 0
    #if DEBUG && targetEnvironment(simulator)
        @State private var injectionRevision = 0
    #endif
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        #if DEBUG && targetEnvironment(simulator)
            _ = injectionRevision
        #endif
        let content = GeometryReader { safeArea in
            GeometryReader { canvas in
                let size = canvas.size
                let minimumHeight = min(collapsedHeight, size.height)
                let maximumHeight = max(minimumHeight, size.height - safeArea.safeAreaInsets.top)
                let travel = maximumHeight - minimumHeight
                let progress = min(max(expansion - dragTranslation / max(travel, 1), 0), 1)
                let dockHeight = minimumHeight + progress * travel
                let panelHeight = size.height - dockHeight

                ZStack(alignment: .topLeading) {
                    Color.monetaBlack
                    MainPanel(surface: selectedSurface, topInset: safeArea.safeAreaInsets.top)
                        .frame(height: panelHeight)
                        .position(x: size.width / 2, y: panelHeight / 2)

                    DockView(
                        selectedSurface: selectedSurface,
                        contentSurface: selectedSurface.opposite,
                        height: dockHeight,
                        bottomInset: safeArea.safeAreaInsets.bottom,
                        expansionProgress: progress,
                        onSelect: { select($0) },
                        onCreate: {},
                        onCollapsedHeightChange: { collapsedHeight = $0 }
                    )
                    .position(x: size.width / 2, y: size.height - dockHeight / 2)

                }
                .frame(width: size.width, height: size.height)
                .contentShape(Rectangle())
                .simultaneousGesture(resizeGesture(travel: travel))
            }
            .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
        #if DEBUG && targetEnvironment(simulator)
            return content.hotReloading(revision: $injectionRevision)
        #else
            return content
        #endif
    }

    private func select(_ surface: Surface) {
        selectedSurface = surface
    }

    private var settleAnimation: Animation? {
        reduceMotion ? nil : .spring(response: 0.32, dampingFraction: 0.92)
    }

    private func resizeGesture(travel: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 3, coordinateSpace: .global)
            .updating($dragTranslation) { value, translation, transaction in
                transaction.animation = nil
                translation = value.translation.height
            }
            .onEnded { value in
                let released = min(max(expansion - value.translation.height / max(travel, 1), 0), 1)
                expansion = released
                if released < collapseThreshold {
                    withAnimation(settleAnimation) {
                        expansion = 0
                    }
                }
            }
    }
}

#Preview {
    RootView()
}
