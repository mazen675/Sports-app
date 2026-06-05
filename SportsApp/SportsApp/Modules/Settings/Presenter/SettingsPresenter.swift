//
//  SettingsPresenter.swift
//  SportsApp
//
//  Created by Mazen Amr on 29/05/2026.
//

import Foundation

class SettingsPresenter: SettingsPresenterProtocol {
    weak var view: SettingsViewProtocol?
    private let defaults: UserDefaultsManaging
    
    init(view: SettingsViewProtocol, defaults: UserDefaultsManaging = UserDefaults.standard) {
        self.view = view
        self.defaults = defaults
    }
    
    func loadPreferences() {
        let isDark = defaults.bool(forKey: "isDarkMode")
        let langIndex = defaults.integer(forKey: "languageIndex")
        
        view?.updateThemeToggle(isDark: isDark)
        view?.updateLanguageSelection(index: langIndex)
    }
    
    func toggleTheme(isDark: Bool) {
        defaults.set(isDark, forKey: "isDarkMode")
        view?.applyThemeChange(isDark: isDark)
    }
    
    func changeLanguage(index: Int) {
        let langCode = (index == 0) ? "en" : "ar"
        
        defaults.set(index, forKey: "languageIndex")
        defaults.set(langCode, forKey: "AppLanguage")
        
        view?.restartApp()
    }
}
