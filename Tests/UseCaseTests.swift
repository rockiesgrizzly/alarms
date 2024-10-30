//
//  UseCaseTests.swift
//  Alarms
//
//  Created by joshmac on 10/25/24.
//

import Foundation
import Testing

@testable import Alarms

final class UseCaseTests {
    @Test("Test Alarms View Model can add a timer from an Alarm Model")
    func addingAlarmModelProducesTimer() async throws {
        let addedAlarmModel = AlarmModel(id: UUID(), date: AlarmModel.mockFutureDate, saved: true, sound: .party, recurrence: .weekly)
        let timer = UseCase_TimerFromAlarmModel.dispatchSourceTimer(for: addedAlarmModel)
        #expect(timer != nil)
    }
}

private extension AlarmModel {
    static var mockFutureDate: Date {
        Date(timeIntervalSinceNow: 40000000)
    }
}
