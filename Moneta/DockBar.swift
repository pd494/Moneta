import SwiftUI

struct DockBar: View {
    @ScaledMetric(relativeTo: .body) private var controlHeight = 62.0
    @ScaledMetric(relativeTo: .body) private var createDiameter = 34.0
    let selectedSurface: Surface
    let onSelect: (Surface) -> Void
    let onCreate: () -> Void
    #if DEBUG && targetEnvironment(simulator)
        @State private var injectionRevision = 0
    #endif

    var body: some View {
        #if DEBUG && targetEnvironment(simulator)
            _ = injectionRevision
        #endif
        let content = HStack(spacing: 0) {
            dockTab(
                surface: .calendar,
                symbol: "calendar",
                label: "Calendar"
            )

            Button(action: onCreate) {
                Image(systemName: "plus")
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color.monetaBlack)
                    .frame(width: createDiameter, height: createDiameter)
                    .background(Color.white, in: Circle())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .frame(height: controlHeight)
            .accessibilityLabel("Create")
            .accessibilityHint("Creating events will be added later")

            dockTab(
                surface: .todos,
                symbol: "checklist",
                label: "Todos"
            )
        }
        .frame(height: controlHeight)
        #if DEBUG && targetEnvironment(simulator)
            return content.hotReloading(revision: $injectionRevision)
        #else
            return content
        #endif
    }
    private func dockTab(
        surface: Surface,
        symbol: String,
        label: String
    ) -> some View {
        Button {
            onSelect(surface)
        } label: {
            Image(systemName: symbol)
                .font(.title3.weight(.medium))
                .foregroundStyle(
                    selectedSurface == surface
                        ? Color.white
                        : Color.monetaTertiary
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .frame(height: controlHeight)
        .accessibilityLabel("Show \(label)")
        .accessibilityAddTraits(selectedSurface == surface ? .isSelected : [])
        .accessibilityIdentifier("\(surface.rawValue)-tab")
    }

}

#Preview {
    DockBar(selectedSurface: .calendar, onSelect: { _ in }, onCreate: {})
}
