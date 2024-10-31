//
//  AlarmDispatchHandler.swift
//  Alarms
//
//  Created by joshmac on 10/30/24.
//

import Foundation


/// Interacts with `UNUserNotificationCenter` to present notifications to the user if granted permission
actor AlarmsDispatchTimerHandler {
    static let shared = AlarmsDispatchTimerHandler()
    
    /// Here we use `DispatchSourceTimer` given it's GCD queue based, allows
    /// precise control over when the timer should fire, and offers simple cancellation.
    private var alarmAlertTimers = [Date: DispatchSourceTimer]()
    
    /// Can only be used through `shared` for safety
    private init() {}
    
    func addAlarmTimer(for alarmModel: AlarmModel) {
        alarmAlertTimers[alarmModel.date] = UseCase_TimerFromAlarmModel.dispatchSourceTimer(for: alarmModel)
    }
    
    func removeAlarmTimer(for date: Date) {
        guard let matchingTimer = alarmAlertTimers[date] else { return }
        matchingTimer.cancel()
        alarmAlertTimers.removeValue(forKey: date)
    }
}
