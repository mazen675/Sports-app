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
  
    var presenter: SettingsPresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = SettingsPresenter(view: self)
        presenter.loadPreferences()
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
