import Foundation

/// Protocol enables injection of test URLSession objects
protocol URLSessionAsycProtocol {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession : URLSessionAsycProtocol { }

class Request<Model: Decodable & Sendable> {
    // MARK: - Async/Await
    
    /// This function takes the provided `requestModel` and utilizes
    /// URLSession to retrieve the desired `ResponseModel`.
    /// - Parameter requestModel: `RequestModel` offers various parameters. This function defaults to
    /// `cachePolicy` : `.reloadIgnoringLocalAndRemoteCacheData` & `timeoutInterval` 0 if not provided in `requestModel`
    /// - Returns: any object conforming to `Decodable`
    public static func asyncGet(_ request: URLRequest, session: any URLSessionAsycProtocol = URLSession.shared) async throws -> Model? {
        let (data, response) = try await session.data(for: request, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw RequestError.httpUrlResponseFailed(response)
        }
        
// // Uncomment to develop if data is not available
//        let data = Data(
//    """
//    [{"timestamp":"2025-01-01T00:00:00+0000","sound":"party","recurring":"yearly"},{"timestamp":"2026-07-11T16:04:00+0000","sound":"brown-noise","recurring":"one-time"},{"timestamp":"2024-09-15T16:04:00+0000","sound":"ocean","recurring":"weekly"},{"timestamp":"2026-07-11T16:04:00+0000","sound":"white-noise","recurring":"one-time"}]
//    """.utf8
//        )
        
        return try JSONDecoder().decode(Model.self, from: data)
    }
    
    // MARK: - Errors
    public enum RequestError: Error {
        case httpUrlResponseFailed(URLResponse)
        case taskCancelled
    }
}
