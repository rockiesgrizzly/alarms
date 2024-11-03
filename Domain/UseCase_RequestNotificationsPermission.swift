import Foundation

protocol UseCase_RequestNotificationsPermissionProtocol {
    static func request()
}

/// Interacts with system notifications handler to request user permission to show notifications
struct UseCase_RequestNotificationsPermission: UseCase_RequestNotificationsPermissionProtocol {
    static func request()  {
        AlarmsNotificationHandler.requestNotificationAuthorization()
    }
}

