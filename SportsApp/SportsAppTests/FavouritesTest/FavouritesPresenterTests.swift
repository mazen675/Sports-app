//
//  FavouritesPresenterTests.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import XCTest
@testable import SportsApp
class FavouritesPresenterTests: XCTestCase {
    
    var view: MockFavouritesView!
    var presenter: FavouritesPresenter!
    var mockCoreData: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        view = MockFavouritesView()
        mockCoreData = MockCoreDataManager()
        presenter = FavouritesPresenter(view: view, coreDataManager: mockCoreData)
    }

    override func tearDown() {
        view = nil
        presenter = nil
        mockCoreData = nil
        super.tearDown()
    }

    func testLoadFavourites_GroupsAndSortsCorrectly() {
        let expectation = expectation(description: "Load Favourites")
        
        mockCoreData.mockEntities = [
            MockFavoriteEntity(data: ["key": "1", "name": "Wimbledon", "sport": "tennis"]),
            MockFavoriteEntity(data: ["key": "2", "name": "Premier League", "sport": "football"])
        ]
        
        presenter.loadFavourites()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.isHideLoadingCalled)
            XCTAssertTrue(self.view.isReloadDataCalled)
            XCTAssertEqual(self.presenter.numberOfSections, 2)
            XCTAssertEqual(self.presenter.titleForSection(0), "Football".localized)
            XCTAssertEqual(self.presenter.titleForSection(1), "Tennis".localized)
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testRemoveFavourite_WhenOnlyOneItemLeft_DeletesSection() {
        let expectation = expectation(description: "Remove Section")
        
        mockCoreData.mockEntities = [
            MockFavoriteEntity(data: ["key": "99", "sport": "football"])
        ]
        presenter.loadFavourites()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter.removeFavourite(at: IndexPath(row: 0, section: 0))
            
            XCTAssertEqual(self.mockCoreData.deletedKey, "99")
            XCTAssertEqual(self.view.deletedSection, 0)
            XCTAssertNil(self.view.deletedRow)
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }

    func testRemoveFavourite_WhenMultipleItemsLeft_DeletesRow() {
        let expectation = expectation(description: "Remove Row")
        
        mockCoreData.mockEntities = [
            MockFavoriteEntity(data: ["key": "1", "sport": "football"]),
            MockFavoriteEntity(data: ["key": "2", "sport": "football"])
        ]
        presenter.loadFavourites()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let indexPathToRemove = IndexPath(row: 1, section: 0)
            self.presenter.removeFavourite(at: indexPathToRemove)
            
            XCTAssertEqual(self.mockCoreData.deletedKey, "2")
            XCTAssertEqual(self.view.deletedRow, indexPathToRemove)
            XCTAssertNil(self.view.deletedSection)
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testDidSelectFavourite_NavigatesProperly() {
        let expectation = expectation(description: "Selection")
        
        mockCoreData.mockEntities = [
            MockFavoriteEntity(data: ["key": "10", "name": "NBA", "sport": "basketball"])
        ]
        presenter.loadFavourites()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter.didSelectFavourite(at: IndexPath(row: 0, section: 0))
            
            XCTAssertEqual(self.view.navigatedLeague?.safeLeagueName, "NBA")
            XCTAssertEqual(self.view.navigatedSport, "basketball")
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}
