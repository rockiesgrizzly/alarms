//
//  DataTests.swift
//  Alarms
//
//  Created by joshmac on 10/25/24.
//

import Foundation
import Testing

@testable import Alarms

final class DomainTests {
    @Test("Use Case Get Alarms Test With Injection")
    func getViewModelsWithInjection() async throws {
        UseCase_GetAlarms.repositoryType = DomainTests.self
        let viewModels = try await UseCase_GetAlarms.alarmDetailViewModels
        #expect(viewModels.count == 2)
        
        let firstViewModel = viewModels[0]
        #expect(firstViewModel.dateString == "December 31, 2024 at 5:00 PM")
        #expect(firstViewModel.alarmModel.saved == true)
        #expect(firstViewModel.alarmModel.sound == .party)
        #expect(firstViewModel.alarmModel.recurrence == .oneTime)
        
        let secondViewModel = viewModels[1]
        #expect(secondViewModel.dateString == "September 15, 2024 at 10:04 AM")
        #expect(secondViewModel.alarmModel.saved == true)
        #expect(secondViewModel.alarmModel.sound == .whiteNoise)
        #expect(secondViewModel.alarmModel.recurrence == .weekly)
    }
    
    @Test("Use Case Get Alarms Test With Real data")
    func getViewModelsWithRealData() async throws {
        let viewModels = try await UseCase_GetAlarms.alarmDetailViewModels
        #expect(viewModels.count > 0)
    }
}

// MARK: - Mocks

extension DomainTests: AlarmsDataRepositoryProtocol {
    static var alarmsResponses: [AlarmResponseModel] {
        get async throws {
            return [responseModel, responseModel2]
        }
    }
    
    private static var responseModel: AlarmResponseModel {
        let timestamp = "2025-01-01T00:00:00+0000"
        let sound = "party"
        let recurring = "one-time"
        return AlarmResponseModel(timestamp: timestamp, sound: sound, recurring: recurring)
    }
    
    private static var responseModel2: AlarmResponseModel {
        let timestamp = "2024-09-15T16:04:00+0000"
        let sound = "brown-noise"
        let recurring = "weekly"
        return AlarmResponseModel(timestamp: timestamp, sound: sound, recurring: recurring)
    }
}
