enum Surface: String {
    case calendar
    case todos

    var opposite: Surface {
        self == .calendar ? .todos : .calendar
    }
}
