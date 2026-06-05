//
//  MockTennisPlayerView.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026

import XCTest
import Alamofire
@testable import SportsApp

class TennisPlayerPresenterTests: XCTestCase {
    
    var view: MockTennisPlayerView!
    var presenter: TennisPlayerPresenter!
    var mockNetwork: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        view = MockTennisPlayerView()
        mockNetwork = MockNetworkService(shouldReturnError: false)
        presenter = TennisPlayerPresenter(view: view, playerId: "123", networkService: mockNetwork)
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testFetchPlayerDetails_Success() {
        let expectation = expectation(description: "Fetch Player")
        
        mockNetwork.fakeJSONObj = [
            "result": [
                [
                    "player_key": "123",
                    "player_name": "Rafael Nadal",
                    "stats": [["season": "2023", "type": "Singles"]],
                    "tournaments": [["name": "Roland Garros"]]
                ]
            ]
        ]
        
        presenter.fetchPlayerDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.isHideLoadingCalled)
            XCTAssertTrue(self.view.isReloadDataCalled)
            
            XCTAssertEqual(self.presenter.numberOfSections, 3)
            XCTAssertEqual(self.presenter.numberOfItems(in: 0), 1)
            XCTAssertEqual(self.presenter.numberOfItems(in: 1), 1)
            
            XCTAssertTrue(self.presenter.hasStats())
            XCTAssertTrue(self.presenter.hasTournaments())
            
            if case .header(let player) = self.presenter.item(at: IndexPath(row: 0, section: 0)) {
                XCTAssertEqual(player.safeName, "Rafael Nadal")
            } else { XCTFail() }
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchPlayerDetails_EmptyStates() {
        let expectation = expectation(description: "Fetch Empty Data")
        
        mockNetwork.fakeJSONObj = [
            "result": [
                [
                    "player_key": "123",
                    "stats": [],
                    "tournaments": []
                ]
            ]
        ]
        
        presenter.fetchPlayerDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.presenter.hasStats())
            XCTAssertFalse(self.presenter.hasTournaments())
            
            if case .emptyState(let title, _) = self.presenter.item(at: IndexPath(row: 0, section: 1)) {
                XCTAssertEqual(title, "no_statistics_title".localized)
            } else { XCTFail() }
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchPlayerDetails_FailureShowsError() {
        let expectation = expectation(description: "Fetch Error")
        
        mockNetwork.shouldReturnError = true
        presenter.fetchPlayerDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.view.errorMessage)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchPlayerDetails_EmptyResultShowsNotFound() {
        let expectation = expectation(description: "Player Not Found")
        
        mockNetwork.fakeJSONObj = ["result": []]
        presenter.fetchPlayerDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.view.errorMessage, "player_not_found".localized)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}
