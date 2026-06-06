//
//  MockLeaguesView.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026.
import XCTest
import Alamofire
@testable import SportsApp

class LeaguesPresenterTests: XCTestCase {
    
    var view: MockLeaguesView!
    var presenter: LeaguesPresenter!
    var mockNetwork: MockNetworkService!
    var mockCoreData: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        view = MockLeaguesView()
        mockNetwork = MockNetworkService(shouldReturnError: false)
        mockCoreData = MockCoreDataManager()
        presenter = LeaguesPresenter(view: view, sportEndpoint: "football", networkService: mockNetwork, coreDataManager: mockCoreData)
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testFetchLeagues_Success() {
        let expectation = expectation(description: "Fetch leagues")
        
        mockNetwork.fakeJSONObj = [
            "result": [
                ["league_key": 1, "league_name": "Premier League"],
                ["league_key": 2, "league_name": "La Liga"]
            ]
        ]
        
        presenter.fetchLeagues()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.isHideLoadingCalled)
            XCTAssertTrue(self.view.isReloadDataCalled)
            XCTAssertEqual(self.presenter.leaguesCount, 2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFilterLeagues() {
        mockNetwork.fakeJSONObj = [
            "result": [
                ["league_key": 1, "league_name": "Premier League"],
                ["league_key": 2, "league_name": "La Liga"]
            ]
        ]
        presenter.fetchLeagues()
        
        let expectation = expectation(description: "Wait for fetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter.filterLeagues(with: "Premier")
            
            XCTAssertEqual(self.presenter.leaguesCount, 1)
            let (league, _, _) = self.presenter.getLeagueData(at: 0)
            XCTAssertEqual(league.safeLeagueName, "Premier League")
            
            self.presenter.filterLeagues(with: "")
            XCTAssertEqual(self.presenter.leaguesCount, 2)
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testDidSelectLeague_NavigatesToDetails() {
        mockNetwork.fakeJSONObj = [
            "result": [["league_key": 1, "league_name": "Serie A"]]
        ]
        presenter.fetchLeagues()
        
        let expectation = expectation(description: "Wait for fetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter.didSelectLeague(at: 0)
            
            XCTAssertNotNil(self.view.navigatedLeague)
            XCTAssertEqual(self.view.navigatedLeague?.safeLeagueName, "Serie A")
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testIsFavorite_ReturnsCorrectState() {
            mockCoreData.favoritedKeys.insert(99)
            
            XCTAssertTrue(presenter.isFavorite(leagueId: 99))
            XCTAssertFalse(presenter.isFavorite(leagueId: 100))
        }
        
        func testToggleFavorite_UpdatesCoreDataAndReloadsView() {
            let dummyLeague = LeagueModel(leagueKey: 55, leagueName: "Test League")
            
            XCTAssertFalse(mockCoreData.isFavorite(key: 55))
            
            presenter.toggleFavorite(league: dummyLeague)
            XCTAssertTrue(mockCoreData.isFavorite(key: 55))
            XCTAssertTrue(view.isReloadDataCalled)
        
            view.isReloadDataCalled = false
            presenter.toggleFavorite(league: dummyLeague)
            XCTAssertFalse(mockCoreData.isFavorite(key: 55))
            XCTAssertTrue(view.isReloadDataCalled)
        }
    
}
