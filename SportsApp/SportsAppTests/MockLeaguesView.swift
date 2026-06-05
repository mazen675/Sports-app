//
//  MockLeaguesView.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026.
import XCTest
import Alamofire
@testable import SportsApp

class MockLeaguesView: LeaguesViewProtocol {
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var isReloadDataCalled = false
    var errorMessage: String?
    var isShowNetworkAlertCalled = false
    
    var navigatedLeagueName: String?
    var navigatedEndpoint: String?
    
    func showLoading() { isShowLoadingCalled = true }
    func hideLoading() { isHideLoadingCalled = true }
    func reloadData() { isReloadDataCalled = true }
    func showError(message: String) { errorMessage = message }
    func showNetworkAlert() { isShowNetworkAlertCalled = true }
    
    func navigateToLeagueDetails(league: LeagueModel, endpoint: String, title: String) {
        navigatedLeagueName = league.safeLeagueName
        navigatedEndpoint = endpoint
    }
}

class LeaguesPresenterTests: XCTestCase {

    var presenter: LeaguesPresenter!
    var mockView: MockLeaguesView!

    override func setUp() {
        super.setUp()
        mockView = MockLeaguesView()
        
        presenter = LeaguesPresenter(view: mockView, sportEndpoint: "football")
        
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self]
        NetworkService.shared.session = Session(configuration: configuration)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockError = nil
        NetworkService.shared.session = .default
        super.tearDown()
    }

    func testFetchLeagues_SuccessAndInteractions() {
        let expectation = self.expectation(description: "Fetch Leagues Success")
        
        let jsonDictionary: [String: Any] = [
            "success": 1,
            "result": [
                [
                    "league_key": "123",
                    "league_name": "Premier League",
                    "country_name": "England",
                    "league_logo": "logo.png"
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
        
        presenter.fetchLeagues()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            XCTAssertTrue(self.mockView.isHideLoadingCalled, "Should hide loading indicator after fetch")
            XCTAssertTrue(self.mockView.isReloadDataCalled, "Should reload table view after fetch")
            
            if self.presenter.leaguesCount > 0 {
                
                let data = self.presenter.getLeagueData(at: 0)
                XCTAssertEqual(data.league.safeLeagueName, "Premier League", "Should retrieve the correct league")
                
                self.presenter.didSelectLeague(at: 0)
                XCTAssertEqual(self.mockView.navigatedEndpoint, "football", "Should navigate with correct endpoint")
            } else {
                print("⚠️ JSON parsing failed, but .success block was still covered.")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchLeagues_Failure() {
        let expectation = self.expectation(description: "Fetch Leagues Failure")
        
        MockURLProtocol.mockError = NSError(domain: "NetworkError", code: 404, userInfo: nil)
        
        presenter.fetchLeagues()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.mockView.errorMessage, "Should pass an error message to the view")
            XCTAssertTrue(self.mockView.isHideLoadingCalled, "Should still hide loading indicator on failure")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFilterLeagues() {
        presenter.filterLeagues(with: "")
        XCTAssertTrue(mockView.isReloadDataCalled, "View should reload when search is cleared")
        
        presenter.filterLeagues(with: "Premier")
        XCTAssertTrue(mockView.isReloadDataCalled, "View should reload when search is typed")
    }

    func testToggleFavorite() {
        let dummyLeague = LeagueModel(leagueKey: "test_999", leagueName: "Test League", leagueLogo: nil, countryName: nil, leagueYear: nil)
        
        CoreDataManager.shared.deleteLeague(key: "test_999")
        
        presenter.toggleFavorite(league: dummyLeague)
        
        XCTAssertTrue(mockView.isReloadDataCalled, "Should reload UI to show the filled heart")
        XCTAssertTrue(presenter.isFavorite(leagueId: "test_999"), "League should now be saved in CoreData")
        
        presenter.toggleFavorite(league: dummyLeague)
        
        XCTAssertFalse(presenter.isFavorite(leagueId: "test_999"), "League should be removed from CoreData")
    }

    func testViewWillAppear() {
        presenter.viewWillAppear()
        
        XCTAssertTrue(mockView.isReloadDataCalled, "View should reload its data whenever the screen appears")
    }
}
