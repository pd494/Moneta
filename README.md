# Moneta for iPhone

Native SwiftUI client for Moneta.

## Linting

From the repository root on macOS, run `bash tools/lint-swift.sh`.
The script downloads and verifies SwiftLint 0.65.1, then checks `Moneta`
using `.swiftlint.yml`. Warnings and errors both fail the check. The same command
runs in the SwiftLint GitHub Actions job on pull requests and pushes to `main`.

Open `Moneta.xcodeproj` in Xcode, or build the `Moneta` scheme with `xcodebuild`.

## Simulator hot reload

With InjectionIII installed at `/Applications/InjectionIII.app`, a Debug Simulator
build automatically watches Swift files under `Moneta/`. Save any of the screen views in
Zed to inject view changes into the running app; no separate watcher command is needed.
The integration is excluded from Release builds and physical-device builds.

Keep build products in `DerivedData`, as configured for this workspace.
Changing stored properties, adding files, or changing project settings requires a
normal rebuild and relaunch. Other view types need the same debug-only notification
observer and type erasure used in `RootView` to redraw after injection.

## View structure

- `RootView`: selection, drag state, resize limits, and panel positioning.
- `MainPanel`: white panel shape and styling.
- `DockView`: black surface, handle, content positioning, and transition progress.
- `DockBar`: Calendar/Create/Todos controls emitting actions to the root.
- `CalendarView` / `TodosView`: independent feature content.
- `MonetaTheme`: shared colors; `HotReloading`: development tooling.

InjectionIII setup: https://github.com/johnno1962/InjectionIII
