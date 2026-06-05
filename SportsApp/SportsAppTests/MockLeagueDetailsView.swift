//
//  MockLeagueDetailsView.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026.
//
import XCTest
import Alamofire
@testable import SportsApp

class MockLeagueDetailsView: LeagueDetailsViewProtocol {
    
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var isReloadDataCalled = false
    var errorMessage: String?
    
    var isShowComingSoonAlertCalled = false
    var navigatedTennisTeamId: String?
    var navigatedDetailsTeamId: String?
    var isShowNetworkAlertCalled = false
    
    func showLoading() { isShowLoadingCalled = true }
    func hideLoading() { isHideLoadingCalled = true }
    func reloadData() { isReloadDataCalled = true }
    func showError(_ message: String) { errorMessage = message }
    func showComingSoonAlert() { isShowComingSoonAlertCalled = true }
    func navigateToTennisPlayer(teamId: String) { navigatedTennisTeamId = teamId }
    func navigateToTeamDetails(teamId: String, sportEndpoint: String, leagueName: String, leagueExtraInfo: String) { navigatedDetailsTeamId = teamId }
    func showNetworkAlert() { isShowNetworkAlertCalled = true }
}

class LeagueDetailsPresenterTests: XCTestCase {

    var mockView: MockLeagueDetailsView!
    var dummyLeague: LeagueModel!

    override func setUp() {
        super.setUp()
        mockView = MockLeagueDetailsView()
        
        dummyLeague = LeagueModel(leagueKey: "123", leagueName: "Test League", leagueLogo: nil, countryName: "Test Country", leagueYear: nil)
        
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self]
        NetworkService.shared.session = Session(configuration: configuration)
    }

    override func tearDown() {
        mockView = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockError = nil
        NetworkService.shared.session = .default
        super.tearDown()
    }
    
    
    func testFetchLeagueDetails_Success() {
        let presenter = LeagueDetailsPresenter(view: mockView, sportEndpoint: "football", league: dummyLeague)
        let expectation = self.expectation(description: "Fetch Details Success")
        
        let jsonDictionary: [String: Any] = [
            "success": 1,
            "result": [
                [
                    "team_key": 123,
                    "team_name": "Test Team",
                    "team_logo": "logo.png",
                    "event_key": 123,
                    "event_date": "2026-01-01",
                    "event_time": "12:00",
                    "event_home_team": "Home",
                    "event_away_team": "Away",
                    "event_final_result": "1-0"
                ]
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            MockURLProtocol.mockData = jsonData
        } catch {
            XCTFail("JSON Serialization failed")
        }
        
        presenter.fetchLeagueDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockView.isHideLoadingCalled, "Should hide loading after fetching")
            
            if presenter.teamsCount == 0 {
                XCTFail("JSON parsing failed! Check if your TeamModel or EventModel requires other non-optional properties.")
            } else {
                XCTAssertGreaterThan(presenter.teamsCount, 0, "Teams should be populated")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchLeagueDetails_Failure() {
        let presenter = LeagueDetailsPresenter(view: mockView, sportEndpoint: "football", league: dummyLeague)
        let expectation = self.expectation(description: "Fetch Details Failure")
        
        MockURLProtocol.mockError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        presenter.fetchLeagueDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            XCTAssertTrue(self.mockView.isHideLoadingCalled, "Hidden")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.5)
    }

    
    func testItemAt_EmptyStates() {
        let presenter = LeagueDetailsPresenter(view: mockView, sportEndpoint: "football", league: dummyLeague)
        
        let upcomingItem = presenter.item(at: IndexPath(row: 0, section: 1))
        switch upcomingItem {
        case .emptyState(let title, let subtitle):
            XCTAssertNotNil(title)
            XCTAssertNotNil(subtitle)
            XCTAssertTrue(true, "Should return empty state for section 1 when no data")
        default:
            XCTFail("Expected empty state for Upcoming Events, but got: \(upcomingItem)")
        }
        
        let latestItem = presenter.item(at: IndexPath(row: 0, section: 2))
        switch latestItem {
        case .emptyState(let title, let subtitle):
            XCTAssertNotNil(title)
            XCTAssertNotNil(subtitle)
            XCTAssertTrue(true, "Should return empty state for section 2 when no data")
        default:
            XCTFail("Expected empty state for Latest Events, but got: \(latestItem)")
        }
    }

    
    func testDidSelectTeam_Basketball_ShowsComingSoon() {
        let presenter = LeagueDetailsPresenter(view: mockView, sportEndpoint: "basketball", league: dummyLeague)
        let expectation = self.expectation(description: "Basketball Route")
        
        populatePresenterWithMockData(presenter: presenter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if presenter.teamsCount > 0 {
                presenter.didSelectTeam(at: 0, section: 0)
                XCTAssertTrue(self.mockView.isShowComingSoonAlertCalled, "Basketball should trigger coming soon alert")
            } else {
                XCTFail("Teams array empty - mock JSON failed to parse.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testDidSelectTeam_Tennis_NavigatesToPlayer() {
        let presenter = LeagueDetailsPresenter(view: mockView, sportEndpoint: "tennis", league: dummyLeague)
        let expectation = self.expectation(description: "Tennis Route")
        
        populatePresenterWithMockData(presenter: presenter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if presenter.teamsCount > 0 {
                presenter.didSelectTeam(at: 0, section: 0)
                XCTAssertNotNil(self.mockView.navigatedTennisTeamId, "Tennis should route to Player screen")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testDidSelectTeam_Football_NavigatesToTeamDetails() {
        let presenter = LeagueDetailsPresenter(view: mockView, sportEndpoint: "football", league: dummyLeague)
        let expectation = self.expectation(description: "Football Route")
        
        populatePresenterWithMockData(presenter: presenter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if presenter.teamsCount > 0 {
                presenter.didSelectTeam(at: 0, section: 0)
                XCTAssertNotNil(self.mockView.navigatedDetailsTeamId, "Football should route to Team Details")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    private func populatePresenterWithMockData(presenter: LeagueDetailsPresenter) {
        let jsonDict: [String: Any] = [
            "success": 1,
            "result": [
                [
                    "team_key": 123,
                    "team_name": "Test Team",
                    "event_key": 123,
                    "event_date": "2026-01-01"
                ]
            ]
        ]
        MockURLProtocol.mockData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        presenter.fetchLeagueDetails()
    }
}
