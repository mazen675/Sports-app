//
//  SettingsContract.swift
//  SportsApp
//
//  Created by Mazen Amr on 29/05/2026.
//

import Foundation

protocol SettingsViewProtocol: AnyObject {
    func updateThemeToggle(isDark: Bool)
    func updateLanguageSelection(index: Int)
    func applyThemeChange(isDark: Bool)
}

protocol SettingsPresenterProtocol {
    func loadPreferences()
    func toggleTheme(isDark: Bool)
    func changeLanguage(index: Int)
}
