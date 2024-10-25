import Foundation

protocol UseCase_ScheduleAlarmNotificationProtocol {
    static func schedule(_ alarm: AlarmModel) async
}

/// Interacts with notifications handler, if user enabled notifications previously, to schedule a notification timed to `alarm`
struct UseCase_ScheduleAlarmNotification: UseCase_ScheduleAlarmNotificationProtocol {
    static func schedule(_ alarm: AlarmModel) async {
        guard let notificationAlarm = alarm.notificationAlarm else { return }
        await AlarmsNotificationHandler.shared.schedule(notificationAlarm)
    }
}

// MARK: - NotificationAlarm : interface

extension AlarmModel {
    var notificationAlarm: NotificationAlarm? {
        return NotificationAlarm(identifier: "\(date)", 
                                 date: date, 
                                 soundName: sound.rawValue, 
                                 recurrence: recurrence)
    }
}

