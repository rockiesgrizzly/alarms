
protocol AlarmsDataRepositoryProtocol {
    static var alarmsResponses: [AlarmResponseModel] { get async throws }
}

/// Holds retrieved `alarmsResponses` data from a service or persistent source
struct AlarmsDataRepository: AlarmsDataRepositoryProtocol {
    static var alarmsServiceType: any AlarmsServiceProtocol.Type = AlarmsService.self
    
    static var alarmsResponses: [AlarmResponseModel] {
        get async throws {
            try await alarmsServiceType.self.alarmsResponses
        }
    }
}

