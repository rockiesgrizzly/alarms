import Foundation

protocol UseCase_TimerFromAlarmModelProtocol {
    static func dispatchSourceTimer(for alarmModel: AlarmModel) -> DispatchSourceTimer?
}

/// Cancels system notification connected to an alarm if user enabled notifications
struct UseCase_TimerFromAlarmModel: UseCase_TimerFromAlarmModelProtocol {
    static func dispatchSourceTimer(for alarmModel: AlarmModel) -> DispatchSourceTimer? {
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
}

