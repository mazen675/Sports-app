//
//  MockSettingsView.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
@testable import SportsApp

class MockSettingsView: SettingsViewProtocol {
    var updatedIsDark: Bool?
    var updatedLanguageIndex: Int?
    var appliedThemeIsDark: Bool?
    var isRestartAppCalled = false
    
    func updateThemeToggle(isDark: Bool) { updatedIsDark = isDark }
    func updateLanguageSelection(index: Int) { updatedLanguageIndex = index }
    func applyThemeChange(isDark: Bool) { appliedThemeIsDark = isDark }
    func restartApp() { isRestartAppCalled = true }
}
