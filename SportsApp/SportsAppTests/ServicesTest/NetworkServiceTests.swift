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

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFetchTeamsInLeague() {
        let myExpectation = expectation(description: "waiting for Teams API ..")
        
        let sportEndpoint = "football"
        let leagueId = "205"
        let expectedNumberOfTeams = 44
        
        let realURL = "\(Constants.baseURL)/\(sportEndpoint)/?met=Teams&leagueId=\(leagueId)&APIkey=\(Constants.apiKey)"
        
        NetworkService.shared.fetchData(from: realURL) { (result: Result<APIResponse<TeamModel>, Error>) in
            
            switch result {
            case .success(let response):
                let teams = response.result
                XCTAssertNotNil(teams, "Teams array should not be nil")
                
                XCTAssertEqual(teams?.count, expectedNumberOfTeams, "Expected \(expectedNumberOfTeams) teams, but got \(teams?.count ?? 0)")
                
                myExpectation.fulfill()
                
            case .failure(let error):
                XCTFail("Network call failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5.0)
    }
}
