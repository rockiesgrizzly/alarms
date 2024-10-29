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
    
    /// Here we use `DispatchSourceTimer` given it's GCD queue based, allows
    /// precise control over when the timer should fire, and offers simple cancellation.
    private var alarmAlertTimers = [Date: DispatchSourceTimer]()
    
    // MARK: - Internal
    
    init(alarmDetailViewModels: [AlarmDetailViewModel] = [AlarmDetailViewModel](), showAlarmTriggeredView: Bool = false, showAlarmEntryView: Bool = false, userCompletedEntryView: Bool = false, userEnteredAlarmDate: Date = Date(), userChosenAlarmSound: AlarmSound = .brownNoise, userChosenRecurrence: AlarmRecurrence = .oneTime, alarmAlertTimers: [Date : DispatchSourceTimer] = [Date: DispatchSourceTimer]()) {
        self.alarmDetailViewModels = alarmDetailViewModels
        self.showAlarmTriggeredView = showAlarmTriggeredView
        self.showAlarmEntryView = showAlarmEntryView
        self.userCompletedEntryView = userCompletedEntryView
        self.userEnteredAlarmDate = userEnteredAlarmDate
        self.userChosenAlarmSound = userChosenAlarmSound
        self.userChosenRecurrence = userChosenRecurrence
        self.alarmAlertTimers = alarmAlertTimers
    }

    @MainActor
    func refreshAlarmDetailModels() async {
        guard let models = try? await UseCase_GetAlarms.alarmDetailViewModels else { return }
        alarmDetailViewModels = models.sorted()
        
        // Ideally, only update new dates here
        
        for model in alarmDetailViewModels {            
            // On screen alert
            addAlarmTimer(for: model.alarmModel)
            
            // Notification if enabled
            Task {
                await UseCase_ScheduleAlarmNotification.schedule(model.alarmModel)
            }
        }
    }
    
    func addAlarmTimer(for alarmModel: AlarmModel) {
        alarmAlertTimers[alarmModel.date] = alarmTimer(for: alarmModel)
    }
    
    func alarmTimer(for alarmModel: AlarmModel) -> DispatchSourceTimer? {
        guard alarmModel.date > Date() else { return nil }
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        let interval = alarmModel.date.timeIntervalSinceNow
        timer.schedule(deadline: .now() + interval)
        
        timer.setEventHandler {
            Task { @MainActor in
                AlarmAlertPresenter.trigger(with: alarmModel)
            }
        }
        timer.resume()
        return timer
    }
    
    func removeAlarmTimer(for date: Date) {
        guard let matchingTimer = alarmAlertTimers[date] else { return }
        matchingTimer.cancel()
        alarmAlertTimers.removeValue(forKey: date)
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
        
        // On screen alert
        addAlarmTimer(for: newViewModel.alarmModel)
        
        // Notification if enabled
        Task {
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


