import Foundation

protocol UseCase_ScheduleAlarmNotificationProtocol {
    static func schedule(_ alarm: AlarmModel)
}

/// Interacts with notifications handler, if user enabled notifications previously, to schedule a notification timed to `alarm`
struct UseCase_ScheduleAlarmNotification: UseCase_ScheduleAlarmNotificationProtocol {
    static func schedule(_ alarm: AlarmModel) {
        guard let notificationAlarm = alarm.notificationAlarm else { return }
        AlarmsNotificationHandler.schedule(notificationAlarm)
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

