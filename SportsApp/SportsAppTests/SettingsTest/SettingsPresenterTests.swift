//
//  SettingsPresenterTests.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import XCTest
@testable import SportsApp

class SettingsPresenterTests: XCTestCase {
    
    var view: MockSettingsView!
    var presenter: SettingsPresenter!
    var mockDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        view = MockSettingsView()
        mockDefaults = MockUserDefaults()
        presenter = SettingsPresenter(view: view, defaults: mockDefaults)
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
        mockDefaults = nil
        super.tearDown()
    }
    
    func testLoadPreferences_UpdatesViewWithSavedValues() {
        mockDefaults.store["isDarkMode"] = true
        mockDefaults.store["languageIndex"] = 1
        
        presenter.loadPreferences()
        
        XCTAssertEqual(view.updatedIsDark, true)
        XCTAssertEqual(view.updatedLanguageIndex, 1)
    }
    
    func testToggleTheme_SavesAndAppliesTheme() {
        presenter.toggleTheme(isDark: true)
        
        XCTAssertEqual(mockDefaults.bool(forKey: "isDarkMode"), true)
        XCTAssertEqual(view.appliedThemeIsDark, true)
    }
    
    func testChangeLanguage_ToEnglish_SavesAndRestarts() {
        presenter.changeLanguage(index: 0)
        
        XCTAssertEqual(mockDefaults.integer(forKey: "languageIndex"), 0)
        XCTAssertEqual(mockDefaults.store["AppLanguage"] as? String, "en")
        XCTAssertTrue(view.isRestartAppCalled)
    }
    
    func testChangeLanguage_ToArabic_SavesAndRestarts() {
        presenter.changeLanguage(index: 1) 
        
        XCTAssertEqual(mockDefaults.integer(forKey: "languageIndex"), 1)
        XCTAssertEqual(mockDefaults.store["AppLanguage"] as? String, "ar")
        XCTAssertTrue(view.isRestartAppCalled)
    }
}
