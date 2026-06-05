//
//  TeamDetailsPresenterTests.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import XCTest
@testable import SportsApp

class TeamDetailsPresenterTests: XCTestCase {
    
    var view: MockTeamDetailsView!
    var presenter: TeamDetailsPresenter!
    var mockNetwork: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        view = MockTeamDetailsView()
        mockNetwork = MockNetworkService(shouldReturnError: false)
        presenter = TeamDetailsPresenter(view: view, sportEndpoint: "football", teamId: "100", leagueExtraInfo: "England", leagueName: "Premier League", networkService: mockNetwork)
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testFetchTeamDetails_SuccessAndSorting() {
        let expectation = expectation(description: "Fetch Team Details")
        
        mockNetwork.fakeJSONObj = [
            "result": [
                [
                    "team_key": "100",
                    "team_name": "Arsenal",
                    "players": [
                        ["player_name": "Saka", "player_type": "Forwards"],
                        ["player_name": "Raya", "player_type": "Goalkeepers"],
                        ["player_name": "Saliba", "player_type": "Defenders"],
                        ["player_name": "Odegaard", "player_type": "Midfielders"]
                    ]
                ]
            ]
        ]
        
        presenter.fetchTeamDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.isHideLoadingCalled)
            XCTAssertNotNil(self.view.displayedTeam)
            XCTAssertEqual(self.view.displayedTeam?.safeTeamName, "Arsenal")
            
            XCTAssertEqual(self.presenter.numberOfSections, 4)
            XCTAssertEqual(self.presenter.getSectionTitle(for: 0), "goalkeepers".localized)
            XCTAssertEqual(self.presenter.getSectionTitle(for: 3), "forwards".localized)
            
            let firstPlayer = self.presenter.getPlayer(at: IndexPath(row: 0, section: 0))
            XCTAssertEqual(firstPlayer.safePlayerName, "Raya")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTeamDetails_EmptyResultShowsError() {
        let expectation = expectation(description: "Fetch Empty Team")
        
        mockNetwork.fakeJSONObj = ["result": []]
        presenter.fetchTeamDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.view.errorMessage, "team_not_found".localized)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
