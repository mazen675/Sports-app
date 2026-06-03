//
//  SettingsViewController.swift
//  SportsApp
//
//  Created by Mazen Amr on 29/05/2026.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewProtocol {

    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var largeTitleLabel: UILabel!
    @IBOutlet weak var darkThemeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
  
    var presenter: SettingsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = SettingsPresenter(view: self)
        presenter.loadPreferences()
        
        setupLocalization()
    }
    
    private func setupLocalization() {
        self.title = "settings_title".localized
        largeTitleLabel.text = "settings_title".localized
        darkThemeLabel.text = "dark_theme".localized
        languageLabel.text = "language".localized
        
        languageSegmentedControl.setTitle("english_language".localized, forSegmentAt: 0)
        languageSegmentedControl.setTitle("arabic_language".localized, forSegmentAt: 1)
    }
    
    @IBAction func didChangeTheme(_ sender: UISwitch) {
        presenter.toggleTheme(isDark: sender.isOn)
    }
    
    @IBAction func didChangeLanguage(_ sender: UISegmentedControl) {
        presenter.changeLanguage(index: sender.selectedSegmentIndex)
    }

    func updateThemeToggle(isDark: Bool) {
        darkThemeSwitch.isOn = isDark
    }
        
    func updateLanguageSelection(index: Int) {
        languageSegmentedControl.selectedSegmentIndex = index
    }
    
    func applyThemeChange(isDark: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
    }
    
        func restartApp() {
            let lang = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
            
            if lang == "ar" {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
                UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
                UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
            }
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
            var rootVC: UIViewController
            
            if hasSeenOnboarding {
                let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                rootVC = UINavigationController(rootViewController: tabBarVC)
            } else {
                rootVC = storyboard.instantiateInitialViewController()!
            }
            
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
}
