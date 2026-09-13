import SwiftUI

extension View {
    #if DEBUG && targetEnvironment(simulator)
        func hotReloading(revision: Binding<Int>) -> some View {
            AnyView(
                onReceive(
                    NotificationCenter.default.publisher(
                        for: Notification.Name("INJECTION_BUNDLE_NOTIFICATION")
                    )
                ) { _ in
                    revision.wrappedValue += 1
                })
        }
    #endif
}

// Development tooling; excluded from device and Release builds.
enum HotReloading {
    static func configure() {
        #if DEBUG && targetEnvironment(simulator)
            guard ProcessInfo.processInfo.environment["CI"] != "true",
                ProcessInfo.processInfo.environment["MONETA_DISABLE_HOT_RELOAD"] != "1"
            else { return }
            let projectDirectory = URL(fileURLWithPath: #filePath)
                .deletingLastPathComponent().deletingLastPathComponent()
            setenv("INJECTION_DIRECTORIES", projectDirectory.path, 1)
            setenv("INJECTION_DERIVED_DATA", projectDirectory.path, 1)
            let logsDirectory = projectDirectory.appendingPathComponent("DerivedData/Logs/Build")
            let logs =
                (try? FileManager.default.contentsOfDirectory(
                    at: logsDirectory, includingPropertiesForKeys: [.contentModificationDateKey]
                )) ?? []
            let latestLog = logs.filter { $0.pathExtension == "xcactivitylog" }.max {
                ((try? $0.resourceValues(forKeys: [.contentModificationDateKey])
                    .contentModificationDate) ?? .distantPast)
                    < ((try? $1.resourceValues(forKeys: [.contentModificationDateKey])
                        .contentModificationDate) ?? .distantPast)
            }
            if let latestLog {
                UserDefaults.standard.set(latestLog.path, forKey: "HotReloadingBuildLogsDir")
            }
            Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?
                .load()
        #endif
    }
}
