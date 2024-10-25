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
    @Test("Use Case Get Alarms Test")
    func getViewModels() async throws {
        let viewModels = try await UseCase_GetAlarms.alarmDetailViewModels
        #expect(viewModels.count > 0)
    }
}

