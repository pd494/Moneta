import SwiftUI

@main
struct MonetaApp: App {
    init() {
        HotReloading.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
