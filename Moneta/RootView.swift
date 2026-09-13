import SwiftUI

struct RootView: View {
    var body: some View {
        GeometryReader { geometry in
            MainPanel(surface: .calendar, topInset: geometry.safeAreaInsets.top)
                .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
        .background(Color.monetaBlack)
    }
}

#Preview {
    RootView()
}
