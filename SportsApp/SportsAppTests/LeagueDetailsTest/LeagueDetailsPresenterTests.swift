//
//  MockLeagueDetailsView.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026.
//
import XCTest
import Alamofire
@testable import SportsApp

class LeagueDetailsPresenterTests: XCTestCase {
    
    var view: MockLeagueDetailsView!
    var presenter: LeagueDetailsPresenter!
    var mockNetwork: MockNetworkService!
    var mockCoreData: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        view = MockLeagueDetailsView()
        mockNetwork = MockNetworkService(shouldReturnError: false)
        mockCoreData = MockCoreDataManager()
        
        let dummyLeague = LeagueModel(leagueKey: "205", leagueName: "Test League")
        presenter = LeagueDetailsPresenter(view: view, sportEndpoint: "football", league: dummyLeague, networkService: mockNetwork, coreDataManager: mockCoreData)
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testFetchLeagueDetails_Success() {
        let expectation = expectation(description: "waiting for DispatchGroup to finish...")

        mockNetwork.fakeJSONObj = [
            "result": [
                [
                    "event_key": "1",
                    "event_status": "Finished",
                    "team_key": "100",
                    "team_name": "Arsenal"
                ],
                [
                    "event_key": "2",
                    "event_status": "Not Started",
                    "team_key": "101",
                    "team_name": "Chelsea"
                ]
            ]
        ]
        
        presenter.fetchLeagueDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.isHideLoadingCalled)
            XCTAssertTrue(self.view.isReloadDataCalled)
            
            XCTAssertEqual(self.presenter.latestEventsCount, 1)
            XCTAssertEqual(self.presenter.upcomingEventsCount, 1)
            XCTAssertEqual(self.presenter.teamsCount, 2)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testItemAtIndexPath_EmptyStates() {
        mockNetwork.fakeJSONObj = ["result": []]
        presenter.fetchLeagueDetails()
        
        let expectation = expectation(description: "Wait for fetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            if case .emptyState(let title, _) = self.presenter.item(at: IndexPath(row: 0, section: 0)) {
                XCTAssertEqual(title, "no_teams_title".localized)
            } else { XCTFail() }
            
            if case .emptyState(let title, _) = self.presenter.item(at: IndexPath(row: 0, section: 1)) {
                XCTAssertEqual(title, "no_upcoming_events_title".localized)
            } else { XCTFail() }
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testDidSelectTeam_Football_NavigatesToTeamDetails() {
        mockNetwork.fakeJSONObj = ["result": [["team_key": "99", "team_name": "FCB"]]]
        presenter.fetchLeagueDetails()
        
        let expectation = expectation(description: "Wait for fetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.presenter.didSelectTeam(at: 0, section: 0)
            XCTAssertEqual(self.view.navigatedToTeamId, "99")
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testDidSelectTeam_Basketball_ShowsComingSoon() {
        let dummyLeague = LeagueModel(leagueKey: "205", leagueName: "Test League")
        presenter = LeagueDetailsPresenter(view: view, sportEndpoint: "basketball", league: dummyLeague, networkService: mockNetwork)
        
        mockNetwork.fakeJSONObj = ["result": [["team_key": "99"]]]
        presenter.fetchLeagueDetails()
        
        let expectation = expectation(description: "Wait for fetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter.didSelectTeam(at: 0, section: 0)
            XCTAssertTrue(self.view.isComingSoonAlertShown)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testIsFavoriteLeague_ReturnsCorrectState() {
            XCTAssertFalse(presenter.isFavoriteLeague())
            
            mockCoreData.favoritedKeys.insert("205")
            
            XCTAssertTrue(presenter.isFavoriteLeague())
        }
        
        func testToggleFavorite_UpdatesCoreDataAndNotifiesView() {
            XCTAssertFalse(mockCoreData.isFavorite(key: "205"))
            
            presenter.toggleFavorite()
            
            XCTAssertTrue(mockCoreData.isFavorite(key: "205"))
            XCTAssertEqual(view.updatedFavoriteState, true)
    
            presenter.toggleFavorite()
            XCTAssertFalse(mockCoreData.isFavorite(key: "205"))
            XCTAssertEqual(view.updatedFavoriteState, false)
        }
        
        func testViewWillAppear_UpdatesFavoriteButtonState() {
            mockCoreData.favoritedKeys.insert("205")
            presenter.viewWillAppear()
            XCTAssertEqual(view.updatedFavoriteState, true)
        }
}
