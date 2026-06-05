//
//  MockSportsView.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026.
//
import XCTest
@testable import SportsApp

class MockSportsView: SportsViewProtocol {
    
    var isDisplaySportsCalled = false
    var navigatedSportName: String?
    var navigatedEndpoint: String?
    
    func displaySports() {
        isDisplaySportsCalled = true
    }
    
    func navigateToLeagues(for sportName: String, endpoint: String) {
        navigatedSportName = sportName
        navigatedEndpoint = endpoint
    }
}

class SportsPresenterTests: XCTestCase {

    var presenter: SportsPresenter!
    var mockView: MockSportsView!

    override func setUp() {
        super.setUp()
        mockView = MockSportsView()
        presenter = SportsPresenter(view: mockView)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        super.tearDown()
    }

    func testSportsCount() {
        let count = presenter.sportsCount
        
        XCTAssertEqual(count, 4, "The sports count should be exactly 4")
    }

    func testConfigureCell() {
        let sport = presenter.configureCell(at: 0)
        
        XCTAssertNotNil(sport, "Sport model should not be nil")
        XCTAssertEqual(sport.name, "Football", "The first sport should be Football")
        XCTAssertEqual(sport.apiEndpoint, "football", "The API endpoint should be 'football'")
    }

    func testDidSelectSport() {
        let selectedIndex = 1
        let expectedSport = presenter.configureCell(at: selectedIndex)
        
        presenter.didSelectSport(at: selectedIndex)
        
        XCTAssertEqual(mockView.navigatedSportName, expectedSport.name, "Presenter should tell the view to navigate to Basketball")
        XCTAssertEqual(mockView.navigatedEndpoint, expectedSport.apiEndpoint, "Presenter should pass the correct endpoint")
    }
}
