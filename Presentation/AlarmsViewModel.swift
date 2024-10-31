import Combine
import Foundation
import UserNotifications

/// Main view model supplying alarms view with data and handling added alarms
class AlarmsViewModel: NSObject, ObservableObject {
    @Published var alarmDetailViewModels = [AlarmDetailViewModel]()
    
    @Published var showAlarmTriggeredView = false
    @Published var showAlarmEntryView = false
    @Published var userCompletedEntryView = false {
        didSet {
            guard userCompletedEntryView else { return }
            let newViewModel = AlarmDetailViewModel(date: userEnteredAlarmDate, 
                                                    saved: false, 
                                                    sound: userChosenAlarmSound, recurrence: userChosenRecurrence)
            userAdded(alarm: newViewModel.alarmModel)
            userCompletedEntryView = false
        }
    }
    
    @Published var userEnteredAlarmDate = Date()
    @Published var userChosenAlarmSound: AlarmSound = .ocean
    @Published var userChosenRecurrence: AlarmRecurrence = .oneTime
    
    // MARK: - Internal

    @MainActor
    func refreshAlarmDetailModels() async {
        guard let models = try? await UseCase_GetAlarms.alarmDetailViewModels else { return }
        alarmDetailViewModels = models.sorted()
        
        // Ideally, only update new dates would be added here if we had local data storage
        
        for model in alarmDetailViewModels {
            // Notification if enabled
            Task {
                // On screen alert
                await AlarmsDispatchTimerHandler.shared.addAlarmTimer(for: model.alarmModel)
                
                // System notification if enabled
                await UseCase_ScheduleAlarmNotification.schedule(model.alarmModel)
            }
        }
    }
    
    func userAdded(alarm: AlarmModel) {
        guard !alarmDetailViewModels.contains(where: {$0.alarmModel.date == alarm.date}) else { return }
        let newViewModel = AlarmDetailViewModel(date: alarm.date, 
                                                saved: alarm.saved, 
                                                sound: alarm.sound, 
                                                recurrence: alarm.recurrence)
        var refreshedModels = alarmDetailViewModels
        refreshedModels.append(newViewModel)
        alarmDetailViewModels = refreshedModels.sorted()
        
        Task {
            // On screen alert
            await AlarmsDispatchTimerHandler.shared.addAlarmTimer(for: newViewModel.alarmModel)
            
            // System notification if enabled
            await UseCase_ScheduleAlarmNotification.schedule(newViewModel.alarmModel)
        }
    }
    
    func userCanceled(alarm: AlarmDetailViewModel) {
        if let (index, foundAlarm) = alarmDetailViewModels.enumerated().first(where: { $0.element.alarmModel.date == alarm.alarmModel.date}) {
            alarmDetailViewModels.remove(at: index)
            
            Task {
                await UseCase_CancelAlarmNotification.cancel(foundAlarm.alarmModel)
            }
        }
    }
    
    func requestUserNotificationPermission() async {
        await UseCase_RequestNotificationsPermission.request()
    }
}

// MARK: - UNUserNotificationCenterDelegate : user enabled system notifications

extension AlarmsViewModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler
     completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}


