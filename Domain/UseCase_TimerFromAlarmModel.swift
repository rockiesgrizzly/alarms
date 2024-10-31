import Foundation

protocol UseCase_TimerFromAlarmModelProtocol {
    static func dispatchSourceTimer(for alarmModel: AlarmModel, completion: (() -> Void)?) -> DispatchSourceTimer?
}

/// Cancels system notification connected to an alarm if user enabled notifications
struct UseCase_TimerFromAlarmModel: UseCase_TimerFromAlarmModelProtocol {
    static func dispatchSourceTimer(for alarmModel: AlarmModel, completion: (() -> Void)? = nil) -> DispatchSourceTimer? {
        // Extract all components but seconds since the user didn't set these
        let componentsSansSeconds = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                         from: alarmModel.date)
        
        guard alarmModel.date > Date(),
              // Start at :00 seconds of the chosen minute since we don't offer seconds
              let dateZeroSeconds = Calendar.current.date(from: componentsSansSeconds) else { return nil }

        // Adjust the interval
        let dateInterval = dateZeroSeconds.timeIntervalSinceNow

        let timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
                        
        timer.schedule(deadline: .now() + dateInterval)

        timer.setEventHandler {
            Task { @MainActor in
                AlarmAlertPresenter.trigger(with: alarmModel)
                completion?()
            }
        }

        timer.resume()
        return timer
    }
}

