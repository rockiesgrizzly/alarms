
protocol AlarmsDataRepositoryProtocol {
    static var alarmsResponses: [AlarmResponseModel] { get async throws }
}

/// Holds retrieved `alarmsResponses` data from a service or persistent source
struct AlarmsDataRepository: AlarmsDataRepositoryProtocol {
    static var alarmsResponses: [AlarmResponseModel] {
        get async throws {
            try await AlarmsService.alarmsResponses
        }
    }
}

