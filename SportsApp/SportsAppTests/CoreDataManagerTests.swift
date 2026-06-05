//
//  CoreDataManagerTests.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 04/06/2026.
//
import XCTest
import CoreData
@testable import SportsApp

class CoreDataManagerTests: XCTestCase {

    var testLeague: LeagueModel!
    let testLeagueKey = "test_12345"

    override func setUp() {
        super.setUp()
        
        testLeague = LeagueModel(
            leagueKey: testLeagueKey,
            leagueName: "Test League",
            leagueLogo: "test_logo.png",
            countryName: "Test Country",
            leagueYear: nil
        )
        
        CoreDataManager.shared.deleteLeague(key: testLeagueKey)
    }

    override func tearDown() {
        CoreDataManager.shared.deleteLeague(key: testLeagueKey)
        super.tearDown()
    }

    func testToggleFavorite_AddsLeague() {
        CoreDataManager.shared.toggleFavorite(league: testLeague, sport: "football")
        
        let isFav = CoreDataManager.shared.isFavorite(key: testLeagueKey)
        XCTAssertTrue(isFav, "League should be saved as a favorite")
    }

    func testToggleFavorite_RemovesLeague() {
        CoreDataManager.shared.toggleFavorite(league: testLeague, sport: "football")
        
        CoreDataManager.shared.toggleFavorite(league: testLeague, sport: "football")
        
        let isFav = CoreDataManager.shared.isFavorite(key: testLeagueKey)
        XCTAssertFalse(isFav, "League should be removed from favorites")
    }

    func testFetchAllFavorites() {
        CoreDataManager.shared.toggleFavorite(league: testLeague, sport: "football")
        
        let allFavorites = CoreDataManager.shared.fetchAllFavorites()
        
        let containsTestLeague = allFavorites.contains { entity in
            return (entity.value(forKey: "key") as? String) == testLeagueKey
        }
        
        XCTAssertTrue(containsTestLeague, "Fetch all should return the saved test league")
    }
}
