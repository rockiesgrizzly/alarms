//
//  DataTests.swift
//  Alarms
//
//  Created by joshmac on 10/25/24.
//

import Foundation
import Testing

@testable import Alarms

final class PresentationTests {
    @Test("Test Alarms View Model can add a timer from an Alarm Model")
    func addingAlarmModelProducesTimer() async throws {
        let mockModel = AlarmsViewModel.mock
        let addedAlarmModel = AlarmModel(id: UUID(), date: AlarmsViewModel.mockFutureDate, saved: true, sound: .party, recurrence: .weekly)
        let timer = mockModel.alarmTimer(for: addedAlarmModel)
        #expect(timer != nil)
    }
}

private extension AlarmsViewModel {
    static var mockFutureDate: Date {
        Date(timeIntervalSinceNow: 40000000)
    }
    
    static var mock: AlarmsViewModel {
        let detail = AlarmDetailViewModel(date: mockFutureDate, saved: true, sound: .brownNoise, recurrence: .oneTime)
        return AlarmsViewModel(alarmDetailViewModels: [detail])
    }
}
