//
//  UserDefaultsManaging.swift
//  SportsApp
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation

protocol UserDefaultsManaging {
    func bool(forKey defaultName: String) -> Bool
    func integer(forKey defaultName: String) -> Int
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsManaging {}
