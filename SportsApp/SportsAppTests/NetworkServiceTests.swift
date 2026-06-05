//
//  NetworkServiceTests.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026.
//
import XCTest
import Alamofire
@testable import SportsApp

class NetworkServiceTests: XCTestCase {

    struct DummyResponse: Decodable {
        let users: [DummyUser]
    }
    
    struct DummyUser: Decodable {
        let id: Int
        let firstName: String
    }

    override func setUp() {
        super.setUp()
        // fake internet
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = Session(configuration: configuration)
        
        // injection
        NetworkService.shared.session = mockSession
    }

    override func tearDown() {
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockError = nil
        NetworkService.shared.session = .default
        super.tearDown()
    }

    func testFetchData_Success() {
        let expectation = self.expectation(description: "Successful API Call")
        
        let jsonDictionary: [String: Any] = [
            "users": [
                [
                    "id": 1,
                    "firstName": "Mr Mazen"
                ]
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            MockURLProtocol.mockData = jsonData
        } catch {
            XCTFail("Failed to serialize JSON mock data: \(error.localizedDescription)")
            return
        }
        
        NetworkService.shared.fetchData(from: "https://dummyjson.com/users") { (result: Result<DummyResponse, Error>) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.users.first?.firstName, "Mr Mazen", "Should parse the mock data correctly")
                XCTAssertEqual(response.users.count, 1)
                expectation.fulfill()
            case .failure:
                XCTFail("The request should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchData_Failure() {
        let expectation = self.expectation(description: "Failed API Call")
        
        MockURLProtocol.mockError = NSError(domain: "NetworkError", code: 404, userInfo: nil)
        
        NetworkService.shared.fetchData(from: "https://badurl.com") { (result: Result<DummyResponse, Error>) in
            switch result {
            case .success:
                XCTFail("The request should fail but it succeeded")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
