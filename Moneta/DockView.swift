import SwiftUI

struct DockView: View {
    let selectedSurface: Surface
    let contentSurface: Surface
    let height: CGFloat
    let bottomInset: CGFloat
    let expansionProgress: CGFloat
    let onSelect: (Surface) -> Void
    let onCreate: () -> Void
    var onCollapsedHeightChange: (CGFloat) -> Void = { _ in }
    private let contentFadeStart: CGFloat = 0.12
    private let contentFadeEnd: CGFloat = 0.28
    #if DEBUG && targetEnvironment(simulator)
        @State private var injectionRevision = 0
    #endif

    var body: some View {
        let visibility = min(
            max((expansionProgress - contentFadeStart) / (contentFadeEnd - contentFadeStart), 0), 1)
        #if DEBUG && targetEnvironment(simulator)
            _ = injectionRevision
        #endif
        let content = ZStack(alignment: .top) {
            Color.monetaBlack

            SurfaceView(surface: contentSurface)
                .environment(\.colorScheme, .dark)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 52)
                .padding(.horizontal, 24)
                .padding(.bottom, max(bottomInset, 16))
                .opacity(visibility)
                .offset(y: 22 * (1 - visibility))
                .allowsHitTesting(visibility > 0.9)
                .accessibilityHidden(visibility < 0.9)

        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .overlay(alignment: .bottom) {
            DockBar(selectedSurface: selectedSurface, onSelect: onSelect, onCreate: onCreate)
                .padding(.top, 12)
                .padding(.bottom, bottomInset)
                .fixedSize(horizontal: false, vertical: true)
                .onGeometryChange(for: CGFloat.self) {
                    $0.size.height
                } action: {
                    onCollapsedHeightChange($0)
                }
                .opacity(1 - visibility)
                .offset(y: 12 * visibility)
                .allowsHitTesting(visibility < 0.1)
                .accessibilityHidden(visibility >= 0.1)
        }
        .overlay(alignment: .top) {
            Capsule()
                .fill(Color(white: 0.28))
                .frame(width: 44, height: 5)
                .padding(.top, 7)
                .frame(width: 100, height: 28, alignment: .top)
                .contentShape(Rectangle())
                .accessibilityLabel("Panel drag handle")
                .accessibilityHint("Drag up for split view, or down to collapse")
        }
        .clipped()
        #if DEBUG && targetEnvironment(simulator)
            return content.hotReloading(revision: $injectionRevision)
        #else
            return content
        #endif
    }
}

#Preview {
    DockView(
        selectedSurface: .calendar, contentSurface: .todos, height: 500, bottomInset: 34,
        expansionProgress: 1,
        onSelect: { _ in }, onCreate: {})
}
