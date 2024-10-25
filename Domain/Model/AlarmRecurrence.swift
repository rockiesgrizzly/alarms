
/// Domain mode to choose how often an alarm should fire
enum AlarmRecurrence: String, CaseIterable {
    case yearly
    case monthly
    case weekly
    case oneTime
    
    var displayString: String {
        switch self {
        case .yearly:
            return "Yearly"
        case .monthly:
            return "Monthly"
        case .weekly:
            return "Weekly"
        case .oneTime:
            return "One Time"
        }
    }
}
