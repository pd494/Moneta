import SwiftUI

struct CalendarView: View {
    var date: Date = .now
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize = 38.0
    #if DEBUG && targetEnvironment(simulator)
        @State private var injectionRevision = 0
    #endif

    var body: some View {
        #if DEBUG && targetEnvironment(simulator)
            _ = injectionRevision
        #endif
        let content = VStack(alignment: .leading, spacing: 0) {
            Text(date, format: .dateTime.month(.wide).year())
                .textCase(.uppercase)
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(.secondary)
            title("Calendar")
            Divider()
                .padding(.top, 26)
            GeometryReader { geometry in
                Rectangle()
                    .fill(.primary.opacity(0.13))
                    .frame(width: geometry.size.width * 0.68)
            }
            .frame(height: 1)
            .padding(.top, 58)
            Spacer()
        }
        #if DEBUG && targetEnvironment(simulator)
            return content.hotReloading(revision: $injectionRevision)
        #else
            return content
        #endif
    }
    private func title(_ value: String) -> some View {
        Text(value)
            .font(.system(size: titleSize, weight: .bold))
            .fixedSize(horizontal: false, vertical: true)
            .tracking(-1.4)
            .foregroundStyle(.primary)
            .padding(.top, 6)
    }

}

#Preview {
    CalendarView().padding(24).background(Color.monetaBlack)
}
