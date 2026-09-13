import SwiftUI

struct TodosView: View {
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize = 38.0
    #if DEBUG && targetEnvironment(simulator)
        @State private var injectionRevision = 0
    #endif

    var body: some View {
        #if DEBUG && targetEnvironment(simulator)
            _ = injectionRevision
        #endif
        let content = VStack(alignment: .leading, spacing: 0) {
            eyebrow("TODAY")
            title("Todos")
            todoPlaceholder(widthFraction: 0.75)
                .padding(.top, 26)
            todoPlaceholder(widthFraction: 0.53)
                .padding(.top, 22)
            Spacer()
        }
        #if DEBUG && targetEnvironment(simulator)
            return content.hotReloading(revision: $injectionRevision)
        #else
            return content
        #endif
    }
    private func eyebrow(_ value: String) -> some View {
        Text(value)
            .font(.caption.weight(.bold))
            .tracking(1.4)
            .foregroundStyle(.secondary)
    }

    private func title(_ value: String) -> some View {
        Text(value)
            .font(.system(size: titleSize, weight: .bold))
            .fixedSize(horizontal: false, vertical: true)
            .tracking(-1.4)
            .foregroundStyle(.primary)
            .padding(.top, 6)
    }

    private func todoPlaceholder(widthFraction: CGFloat) -> some View {
        HStack(spacing: 14) {
            Circle()
                .stroke(.primary.opacity(0.6), lineWidth: 1.5)
                .frame(width: 20, height: 20)
            GeometryReader { geometry in
                Capsule(style: .continuous)
                    .fill(.primary.opacity(0.2))
                    .frame(width: geometry.size.width * widthFraction, height: 8)
            }
            .frame(height: 8)
        }
    }

}

#Preview {
    TodosView().padding(24).background(Color.monetaBlack)
}
