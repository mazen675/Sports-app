//
//  MockLeaguesView.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
@testable import SportsApp

class MockLeaguesView: LeaguesViewProtocol {
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var isReloadDataCalled = false
    var errorMessage: String?
    var navigatedLeague: LeagueModel?
    
    func showLoading() { isShowLoadingCalled = true }
    func hideLoading() { isHideLoadingCalled = true }
    func reloadData() { isReloadDataCalled = true }
    func showError(message: String) { errorMessage = message }
    func showNetworkAlert() {}
    
    func navigateToLeagueDetails(league: LeagueModel, endpoint: String, title: String) {
        navigatedLeague = league
    }
}
