//
//  MockCoreDataManager.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
@testable import SportsApp

class MockFavoriteEntity: NSObject {
    var data: [String: Any]
    
    init(data: [String: Any]) {
        self.data = data
    }
    
    override func value(forKey key: String) -> Any? {
        return data[key]
    }
}

class MockCoreDataManager: CoreDataManaging {
    var mockEntities: [NSObject] = []
    var deletedKey: String?
    var favoritedKeys: Set<String> = []
    
    func fetchAllFavorites() -> [NSObject] {
        return mockEntities
    }
    
    func deleteLeague(key: String) {
        deletedKey = key
    }
    
    func isFavorite(key: String) -> Bool {
            return favoritedKeys.contains(key)
        }
        
    func toggleFavorite(league: LeagueModel, sport: String) {
        guard let key = league.leagueKey else { return }
        if favoritedKeys.contains(key) {
            favoritedKeys.remove(key)
        } else {
            favoritedKeys.insert(key)
        }
    }
}

