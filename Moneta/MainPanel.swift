import SwiftUI

struct MainPanel: View {
    var surface: Surface = .calendar
    var topInset: CGFloat = 0
    private let bottomCornerRadius: CGFloat = 76
    #if DEBUG && targetEnvironment(simulator)
        @State private var injectionRevision = 0
    #endif

    var body: some View {
        #if DEBUG && targetEnvironment(simulator)
            _ = injectionRevision
        #endif
        let content = UnevenRoundedRectangle(
            cornerRadii: .init(
                bottomLeading: bottomCornerRadius, bottomTrailing: bottomCornerRadius),
            style: .continuous
        )
        .fill(Color.monetaPaper)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .topLeading) {
            SurfaceView(surface: surface)
                .padding(.horizontal, 24)
                .padding(.top, topInset + 24)
                .padding(.bottom, bottomCornerRadius)
                .environment(\.colorScheme, .light)
        }
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    bottomLeading: bottomCornerRadius, bottomTrailing: bottomCornerRadius),
                style: .continuous
            )
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("main-panel")
        #if DEBUG && targetEnvironment(simulator)
            return content.hotReloading(revision: $injectionRevision)
        #else
            return content
        #endif
    }
}

#Preview {
    MainPanel()
}
