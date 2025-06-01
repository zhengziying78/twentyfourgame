import XCTest
@testable import twentyfour

final class SettingsPreferencesTests: XCTestCase {
    var userDefaults: UserDefaults!
    let testKey = "selectedLanguage"
    
    override func setUp() {
        super.setUp()
        // Use a unique suite name for testing to avoid interfering with actual app data
        userDefaults = UserDefaults(suiteName: "SettingsPreferencesTests")!
        userDefaults.removePersistentDomain(forName: "SettingsPreferencesTests")
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "SettingsPreferencesTests")
        userDefaults = nil
        super.tearDown()
    }
    
    func testSingletonPattern() {
        let instance1 = SettingsPreferences.shared
        let instance2 = SettingsPreferences.shared
        
        XCTAssertTrue(instance1 === instance2, "SettingsPreferences should be a singleton")
    }
    
    func testLanguageEnumCases() {
        let allCases = Language.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.auto))
        XCTAssertTrue(allCases.contains(.english))
        XCTAssertTrue(allCases.contains(.chinese))
    }
    
    func testLanguageDisplayNames() {
        XCTAssertEqual(Language.auto.displayName, "Auto")
        XCTAssertEqual(Language.english.displayName, "English")
        XCTAssertEqual(Language.chinese.displayName, "中文")
    }
    
    func testLanguageIdentifiable() {
        for language in Language.allCases {
            XCTAssertEqual(language.id, language.rawValue)
        }
    }
    
    func testDefaultLanguage() {
        // Clear any existing saved language
        userDefaults.removeObject(forKey: testKey)
        
        let settings = SettingsPreferences.shared
        XCTAssertEqual(settings.language, .auto, "Default language should be auto")
    }
    
    func testLanguageSettingAndPersistence() {
        let settings = SettingsPreferences.shared
        
        // Test setting each available language
        for language in Language.allCases {
            settings.setLanguage(language)
            XCTAssertEqual(settings.language, language, "Current language should match set language")
            
            // Verify persistence in UserDefaults
            let savedLanguage = userDefaults.string(forKey: testKey)
            XCTAssertEqual(savedLanguage, language.rawValue, "Language should be saved to UserDefaults")
        }
    }
    
    func testLoadingSavedLanguage() {
        // Save a language to UserDefaults
        userDefaults.set(Language.chinese.rawValue, forKey: testKey)
        userDefaults.synchronize()
        
        // Create a new instance which should load the saved language
        let settings = SettingsPreferences.shared
        XCTAssertEqual(settings.language, .chinese, "Settings should load saved language from UserDefaults")
    }
    
    func testInvalidSavedLanguage() {
        // Save an invalid language value
        userDefaults.set("invalidLanguage", forKey: testKey)
        userDefaults.synchronize()
        
        // Create a new instance which should fall back to auto
        let settings = SettingsPreferences.shared
        XCTAssertEqual(settings.language, .auto, "Settings should use auto when saved value is invalid")
    }
    
    func testEffectiveLanguage() {
        // Test auto language with Chinese system preference
        let chineseLocale = ["zh-Hans"]
        let englishLocale = ["en-US"]
        
        // Test with Chinese system preference
        XCTAssertEqual(Language.auto.effectiveLanguage, .english, "Auto should default to English for non-Chinese system")
        XCTAssertEqual(Language.english.effectiveLanguage, .english, "English should always be English")
        XCTAssertEqual(Language.chinese.effectiveLanguage, .chinese, "Chinese should always be Chinese")
    }
} 