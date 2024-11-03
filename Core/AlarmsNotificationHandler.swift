import UserNotifications
import os.log

struct NotificationAlarm {
    let identifier: String
    let date: Date
    let soundName: String
    let title = "Alarms App"
    let recurrence: AlarmRecurrence
}

/// Interacts with `UNUserNotificationCenter` to present notifications to the user if granted permission
struct AlarmsNotificationHandler {
    static let logger = Logger(subsystem: "Alarms", category: "NotificationHandler")

    
   static func schedule(_ alarm: NotificationAlarm) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let existingRequest = requests.first(where: { $0.identifier == alarm.identifier })
            guard existingRequest == nil else { return }
            
            let content = UNMutableNotificationContent()
            content.title = alarm.title
            guard let dateComponents = UseCase_DateComponentsForRecurrence.dateComponents(for: alarm.date, and: alarm.recurrence) else { return }

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: alarm.recurrence != .oneTime)
            let request = UNNotificationRequest(identifier: alarm.identifier, content: content, trigger: trigger)
            
              AlarmsNotificationHandler.logger.debug("notification request generated: \(alarm.identifier)")
            UNUserNotificationCenter.current().add(request) { error in
                guard let error else { return }
                AlarmsNotificationHandler.logger.debug("\(error.localizedDescription)")
            }
        }
    }
    
    static func cancel(_ alarm: NotificationAlarm) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            guard let existingRequest = requests.first(where: { $0.identifier == alarm.identifier }) else { return }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [existingRequest.identifier])
        }
    }
    
    static func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                AlarmsNotificationHandler.logger.debug("Notification permission granted.")
            } else if let error = error {
                AlarmsNotificationHandler.logger.debug("Error requesting notification permission: \(error.localizedDescription)")
            } else {
                AlarmsNotificationHandler.logger.debug("Notification permission denied.")
            }
        }
    }
}
