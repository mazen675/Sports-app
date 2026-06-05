//
//  MockFavouritesView.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
@testable import SportsApp
class MockFavouritesView: FavouritesViewProtocol {
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var isReloadDataCalled = false
    var deletedSection: Int?
    var deletedRow: IndexPath?
    var navigatedLeague: LeagueModel?
    var navigatedSport: String?
    
    func showLoading() { isShowLoadingCalled = true }
    func hideLoading() { isHideLoadingCalled = true }
    func reloadData() { isReloadDataCalled = true }
    
    func deleteSection(at index: Int) { deletedSection = index }
    func deleteRow(at indexPath: IndexPath) { deletedRow = indexPath }
    
    func navigateToLeagueDetails(league: LeagueModel, sportEndpoint: String) {
        navigatedLeague = league
        navigatedSport = sportEndpoint
    }
}
