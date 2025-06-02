import XCTest
@testable import twentyfour

final class LanguagePreferencesTests: XCTestCase {
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        // Create a unique UserDefaults instance for testing
        userDefaults = UserDefaults(suiteName: "LanguagePreferencesTests")!
        userDefaults.removePersistentDomain(forName: "LanguagePreferencesTests")
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "LanguagePreferencesTests")
        super.tearDown()
    }
    
    func testSingleton() {
        // Test that we get the same instance each time
        let instance1 = LanguagePreferences.shared
        let instance2 = LanguagePreferences.shared
        
        XCTAssertTrue(instance1 === instance2, "LanguagePreferences should be a singleton")
    }
    
    func testDefaultLanguage() {
        // Clear any existing preferences
        userDefaults.removeObject(forKey: "selectedLanguage")
        
        // Get a fresh instance
        let settings = LanguagePreferences.shared
        
        // Test that the default language is .auto
        XCTAssertEqual(settings.language, .auto)
    }
    
    func testLanguagePersistence() {
        // Set a language
        let settings = LanguagePreferences.shared
        settings.setLanguage(.english)
        
        // Check that the language was saved
        let savedLanguage = userDefaults.string(forKey: "selectedLanguage")
        XCTAssertEqual(savedLanguage, "English")
        
        // Check that the language is loaded correctly
        XCTAssertEqual(settings.language, .english)
    }
    
    func testEffectiveLanguage() {
        let settings = LanguagePreferences.shared
        
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
        let settings = LanguagePreferences.shared
        
        XCTAssertEqual(Language.auto.displayName, "Auto")
        XCTAssertEqual(Language.english.displayName, "English")
        XCTAssertEqual(Language.chinese.displayName, "中文")
    }
} 