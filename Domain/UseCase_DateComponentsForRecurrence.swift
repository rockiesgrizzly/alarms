import Foundation

protocol UseCase_DateComponentsForRecurrenceProtocol {
    static func dateComponents(for date: Date, and recurrence: AlarmRecurrence) -> DateComponents?
}

/// Cancels system notification connected to an alarm if user enabled notifications
struct UseCase_DateComponentsForRecurrence: UseCase_DateComponentsForRecurrenceProtocol {
    static func dateComponents(for date: Date, and recurrence: AlarmRecurrence) -> DateComponents? {
        var dateComponents = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: date)
        
        switch recurrence {
        case .yearly:
            dateComponents = Calendar.autoupdatingCurrent.dateComponents([.month, .day, .hour, .minute], from: date) // Include .month
        case .monthly:
            dateComponents = Calendar.autoupdatingCurrent.dateComponents([.day, .hour, .minute], from: date) // Include .day
        case .weekly:
            dateComponents = Calendar.autoupdatingCurrent.dateComponents([.weekday, .hour, .minute], from: date)
        case .oneTime:
            dateComponents = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        }
        
        dateComponents.timeZone = .current
        
        return dateComponents
    }
}

