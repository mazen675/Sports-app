//
//  SettingsPresenter.swift
//  SportsApp
//
//  Created by Mazen Amr on 29/05/2026.
//

import Foundation

class SettingsPresenter: SettingsPresenterProtocol {
    weak var view: SettingsViewProtocol?
    
    init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    func loadPreferences() {
        let isDark = UserDefaults.standard.bool(forKey: "isDarkMode")
        let langIndex = UserDefaults.standard.integer(forKey: "languageIndex")
        
        view?.updateThemeToggle(isDark: isDark)
        view?.updateLanguageSelection(index: langIndex)
    }
    
    func toggleTheme(isDark: Bool) {
        UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        view?.applyThemeChange(isDark: isDark)
    }
    
    func changeLanguage(index: Int) {
        let langCode = (index == 0) ? "en" : "ar"
        
        UserDefaults.standard.set(index, forKey: "languageIndex")
        UserDefaults.standard.set(langCode, forKey: "AppLanguage")
        
        view?.restartApp()
    }
}
