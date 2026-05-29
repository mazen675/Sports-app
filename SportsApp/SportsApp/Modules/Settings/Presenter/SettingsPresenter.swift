//
//  SettingsPresenter.swift
//  SportsApp
//
//  Created by Mazen Amr on 29/05/2026.
//

import Foundation
import UIKit

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

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
    }
    
    func changeLanguage(index: Int) {
        UserDefaults.standard.set(index, forKey: "languageIndex")
        
    }
}
