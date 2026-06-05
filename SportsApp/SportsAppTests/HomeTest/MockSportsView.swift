//
//  MockSportsView.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
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
