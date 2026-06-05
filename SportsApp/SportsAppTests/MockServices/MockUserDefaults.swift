//
//  MockUserDefaults.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
@testable import SportsApp

class MockUserDefaults: UserDefaultsManaging {
    var store: [String: Any] = [:]
    
    func bool(forKey defaultName: String) -> Bool {
        return store[defaultName] as? Bool ?? false
    }
    
    func integer(forKey defaultName: String) -> Int {
        return store[defaultName] as? Int ?? 0
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        store[defaultName] = value
    }
}
