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
    @Test("Test Alarms View Model adds a timer from an Alarm Model")
    func addingAlarmModelProducesTimer() async throws {
        let addedAlarmModel = AlarmModel(id: UUID(), date: AlarmModel.mockFutureDate, saved: true, sound: .party, recurrence: .weekly)
        let timer = UseCase_TimerFromAlarmModel.dispatchSourceTimer(for: addedAlarmModel)
        #expect(timer != nil)
    }
    
    @Test("Test Date & Recurrence produce Date Components")
    func dateAndRecurrenceProducesComponents() async throws {
        let dateComponents = UseCase_DateComponentsForRecurrence.dateComponents(for: AlarmModel.mockFutureDate, and: .weekly)
        #expect(dateComponents != nil)
    }
}

private extension AlarmModel {
    static var mockFutureDate: Date {
        Date(timeIntervalSinceNow: 40000000)
    }
}
