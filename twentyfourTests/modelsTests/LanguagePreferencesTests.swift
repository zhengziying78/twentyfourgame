import XCTest
@testable import twentyfour

final class LanguagePreferencesTests: XCTestCase {
    var userDefaults: UserDefaults!
    var settings: LanguagePreferences!
    let languageKey = "selectedLanguage"
    
    override func setUp() {
        super.setUp()
        
        // Create a unique UserDefaults instance for testing
        userDefaults = UserDefaults(suiteName: "LanguagePreferencesTests")!
        userDefaults.removePersistentDomain(forName: "LanguagePreferencesTests")
        settings = LanguagePreferences.createForTesting(defaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "LanguagePreferencesTests")
        userDefaults = nil
        settings = nil
        super.tearDown()
    }
    
    func testSingleton() {
        // Test that we get the same instance each time
        let instance1 = LanguagePreferences.shared
        let instance2 = LanguagePreferences.shared
        
        XCTAssertTrue(instance1 === instance2, "LanguagePreferences should be a singleton")
        
        // Also verify that custom instances are different
        let customInstance1 = LanguagePreferences.createForTesting(defaults: userDefaults)
        let customInstance2 = LanguagePreferences.createForTesting(defaults: userDefaults)
        XCTAssertFalse(customInstance1 === customInstance2, "Custom instances should be different")
        XCTAssertFalse(customInstance1 === instance1, "Custom instance should be different from singleton")
    }
    
    func testDefaultLanguage() {
        // Clear any existing preferences
        userDefaults.removeObject(forKey: languageKey)
        
        // Create a new instance to test initialization
        let testSettings = LanguagePreferences.createForTesting(defaults: userDefaults)
        
        // Test that the default language is .auto
        XCTAssertEqual(testSettings.language, .auto)
    }
    
    func testLanguagePersistence() {
        // Set a language
        settings.setLanguage(.english)
        
        // Check that the language was saved
        let savedLanguage = userDefaults.string(forKey: languageKey)
        XCTAssertEqual(savedLanguage, "English")
        
        // Create a new instance to verify loading
        let newSettings = LanguagePreferences.createForTesting(defaults: userDefaults)
        XCTAssertEqual(newSettings.language, .english)
    }
    
    func testEffectiveLanguage() {
        // Test English
        settings.setLanguage(.english)
        XCTAssertEqual(settings.language.effectiveLanguage, .english)
        
        // Test Chinese
        settings.setLanguage(.chinese)
        XCTAssertEqual(settings.language.effectiveLanguage, .chinese)
        
        // Test Auto (this will depend on system settings)
        settings.setLanguage(.auto)
        XCTAssertTrue([.english, .chinese].contains(settings.language.effectiveLanguage))
    }
    
    func testLanguageDisplayNames() {
        XCTAssertEqual(Language.auto.displayName, "Auto")
        XCTAssertEqual(Language.english.displayName, "English")
        XCTAssertEqual(Language.chinese.displayName, "中文")
    }
} 