//
//  DataTests.swift
//  Alarms
//
//  Created by joshmac on 10/25/24.
//

import Foundation
import Testing

@testable import Alarms

final class DataTests {
    @Test("Data Repository Test")
    func repository() async throws {
        let responses = try await AlarmsDataRepository.alarmsResponses
        #expect(responses.count > 1)
    }
}


final class RequestTests {
    static let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
    static let request = URLRequest(url: url)
    static let session = TestURLSession()
    
    @Test("Request.asyncGet Success")
    static func asyncGetSuccess() async throws {
        let model: MockModel? = try await Request<MockModel>.asyncGet(request, session: session)
        #expect(model != nil)
        #expect(model?.id == 1)
        #expect(model?.name == "delectus aut autem")
    }
}

// MARK: - Test Models

private let modelId = 1
private let modelString = "delectus aut autem"

// Sample Model struct for testing
struct MockModel: Codable, Equatable {
    let id: Int
    let name: String
}

struct TestURLSession: URLSessionAsycProtocol {
    static let model = MockModel(id: modelId, name: modelString)
    var data = try! JSONEncoder().encode(model)
    static let url = URL(string: "u2.com")! // unused
    static let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        return (data, TestURLSession.response)
    }
}
