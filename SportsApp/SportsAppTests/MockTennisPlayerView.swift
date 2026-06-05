//
//  MockTennisPlayerView.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026
import XCTest
import Alamofire
@testable import SportsApp // 🚨 Replace with your exact project name

// MARK: - 1. The Mock View
class MockTennisPlayerView: TennisPlayerViewProtocol {
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var isReloadDataCalled = false
    var errorMessage: String?
    var isShowNetworkAlertCalled = false
    
    func showLoading() { isShowLoadingCalled = true }
    func hideLoading() { isHideLoadingCalled = true }
    func reloadData() { isReloadDataCalled = true }
    func showError(message: String) { errorMessage = message }
    func showNetworkAlert() { isShowNetworkAlertCalled = true }
}

// MARK: - 2. The Test Cases
class TennisPlayerPresenterTests: XCTestCase {
    
    var mockView: MockTennisPlayerView!
    var presenter: TennisPlayerPresenter!
    
    override func setUp() {
        super.setUp()
        mockView = MockTennisPlayerView()
        presenter = TennisPlayerPresenter(view: mockView, playerId: "123")
        
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self]
        NetworkService.shared.session = Session(configuration: configuration)
    }
    
    override func tearDown() {
        mockView = nil
        presenter = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockError = nil
        NetworkService.shared.session = .default
        super.tearDown()
    }
    
    // 🎯 Test 1: Fetch Success with FULL Data
        func testFetchPlayerDetails_Success_WithData() {
            let expectation = self.expectation(description: "Fetch Player Success")
            
            // 🚨 Converted back to a Swift Dictionary (JSONSerialization)
            // 🚨 Note: The key here is strictly "stats" so it matches your CodingKeys perfectly!
            let jsonDict: [String: Any] = [
                "success": 1,
                "result": [
                    [
                        "player_key": 123,
                        "player_name": "Rafael Nadal",
                        "player_country": "Spain",
                        "player_bday": "1986-06-03",
                        "player_logo": "logo.png",
                        "stats": [
                            [
                                "season": "2026",
                                "type": "ATP",
                                "rank": "1",
                                "titles": "10",
                                "matches_won": "50",
                                "matches_lost": "5",
                                "hard_won": "20",
                                "clay_won": "20",
                                "grass_won": "10",
                                "hard_lost": "2",
                                "clay_lost": "1",
                                "grass_lost": "2"
                            ]
                        ],
                        "tournaments": [
                            [
                                "name": "Wimbledon",
                                "season": "2026",
                                "type": "Grand Slam",
                                "surface": "Grass",
                                "prize": "2000000"
                            ]
                        ]
                    ]
                ]
            ]
            
            // Safely serialize the dictionary to Data
            do {
                MockURLProtocol.mockData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            } catch {
                XCTFail("JSON Serialization failed: \(error.localizedDescription)")
                return
            }
            
            presenter.fetchPlayerDetails()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                XCTAssertTrue(self.mockView.isReloadDataCalled, "View should reload with new data")
                
                XCTAssertEqual(self.presenter.numberOfSections, 3, "Should have 3 sections")
                XCTAssertTrue(self.presenter.hasStats(), "Should detect stats")
                XCTAssertTrue(self.presenter.hasTournaments(), "Should detect tournaments")
                
                XCTAssertEqual(self.presenter.numberOfItems(in: 0), 1)
                XCTAssertEqual(self.presenter.numberOfItems(in: 1), 1)
                XCTAssertEqual(self.presenter.numberOfItems(in: 2), 1)
                XCTAssertEqual(self.presenter.numberOfItems(in: 99), 0)
                
                let headerItem = self.presenter.item(at: IndexPath(row: 0, section: 0))
                switch headerItem { case .header(_): XCTAssertTrue(true); default: XCTFail() }
                
                let statItem = self.presenter.item(at: IndexPath(row: 0, section: 1))
                switch statItem { case .stat(_): XCTAssertTrue(true); default: XCTFail() }
                
                let tourneyItem = self.presenter.item(at: IndexPath(row: 0, section: 2))
                switch tourneyItem { case .tournament(_): XCTAssertTrue(true); default: XCTFail() }
                
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 2.0)
        }
    
    // 🎯 Test 2: Fetch Success with EMPTY Arrays
    func testFetchPlayerDetails_Success_EmptyArrays() {
        let expectation = self.expectation(description: "Fetch Player Empty Arrays")
        
        let jsonString = """
        {
            "success": 1,
            "result": [
                {
                    "player_key": 123,
                    "player_name": "Rafael Nadal"
                }
            ]
        }
        """
        MockURLProtocol.mockData = jsonString.data(using: .utf8)
        
        presenter.fetchPlayerDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.presenter.hasStats(), "Should detect NO stats")
            XCTAssertFalse(self.presenter.hasTournaments(), "Should detect NO tournaments")
            
            XCTAssertEqual(self.presenter.numberOfItems(in: 1), 1)
            XCTAssertEqual(self.presenter.numberOfItems(in: 2), 1)
            
            let statItem = self.presenter.item(at: IndexPath(row: 0, section: 1))
            switch statItem { case .emptyState(_, _): XCTAssertTrue(true); default: XCTFail() }
            
            let tourneyItem = self.presenter.item(at: IndexPath(row: 0, section: 2))
            switch tourneyItem { case .emptyState(_, _): XCTAssertTrue(true); default: XCTFail() }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // 🎯 Test 3: Player Not Found
    func testFetchPlayerDetails_PlayerNotFound() {
        let expectation = self.expectation(description: "Fetch Player Not Found")
        
        let jsonString = """
        {
            "success": 1,
            "result": []
        }
        """
        MockURLProtocol.mockData = jsonString.data(using: .utf8)
        
        presenter.fetchPlayerDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.mockView.errorMessage, "Should show an error if player data is missing")
            XCTAssertEqual(self.presenter.numberOfSections, 0, "Sections should be 0 if player is nil")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // 🎯 Test 4: Network Failure
    func testFetchPlayerDetails_Failure() {
        let expectation = self.expectation(description: "Fetch Player Failure")
        
        MockURLProtocol.mockError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        presenter.fetchPlayerDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockView.isHideLoadingCalled, "Should hide loading indicator on error")
            XCTAssertNotNil(self.mockView.errorMessage, "Should pass error message to view")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // 🎯 Test 5: Lifecycle Method
    func testViewWillAppear() {
        presenter.viewWillAppear()
        XCTAssertNotNil(presenter, "Presenter should exist")
    }
}
