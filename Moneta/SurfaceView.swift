import SwiftUI

/// The same feature content can appear in either panel.
struct SurfaceView: View {
    let surface: Surface

    var body: some View {
        switch surface {
        case .calendar: CalendarView()
        case .todos: TodosView()
        }
    }
}
