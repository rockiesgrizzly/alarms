import Foundation 

protocol AlarmsServiceProtocol {
    static var alarmsResponses: [AlarmResponseModel] { get async throws }
}

/// Retrieves `alarmsResponses` from an endpoint
struct AlarmsService: AlarmsServiceProtocol {
    private static let alarmEndpointUrl = "https://671267816c5f5ced6623613b.mockapi.io/alarms"
    private static let url = URL(string: alarmEndpointUrl)!
    private static let request = URLRequest(url: url)
    
    static var alarmsResponses: [AlarmResponseModel] {
        get async throws {
            guard let response =  try await Request<[AlarmResponseModel]>.asyncGet(request) else { throw AlarmsServiceError.responseFailed }
            return response
        }
    }
}

enum AlarmsServiceError: Error {
    case responseFailed
}





