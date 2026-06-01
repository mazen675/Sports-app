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
        
        languageSegmentedControl.setTitle("arabic_language".localized, forSegmentAt: 0)
        languageSegmentedControl.setTitle("english_language".localized, forSegmentAt: 1)
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

}
