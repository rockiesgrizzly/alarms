import Foundation

protocol UseCase_CancelAlarmNotificationProtocol {
    static func cancel(_ alarm: AlarmModel) async
}

/// Cancels system notification connected to an alarm if user enabled notifications
struct UseCase_CancelAlarmNotification: UseCase_CancelAlarmNotificationProtocol {
    static func cancel(_ alarm: AlarmModel) async {
        guard let notificationAlarm = alarm.notificationAlarm else { return }
        AlarmsNotificationHandler.cancel(notificationAlarm)
    }
}

