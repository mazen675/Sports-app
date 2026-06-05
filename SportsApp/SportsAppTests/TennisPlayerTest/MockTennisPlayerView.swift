//
//  MockTennisPlayerView.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 04/06/2026.
//

import Foundation
@testable import SportsApp

class MockTennisPlayerView: TennisPlayerViewProtocol {
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var isReloadDataCalled = false
    var errorMessage: String?
    
    func showLoading() { isShowLoadingCalled = true }
    func hideLoading() { isHideLoadingCalled = true }
    func reloadData() { isReloadDataCalled = true }
    func showError(message: String) { errorMessage = message }
    func showNetworkAlert() {}
}
