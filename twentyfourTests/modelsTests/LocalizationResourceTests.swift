import XCTest
@testable import twentyfour

final class LocalizationResourceTests: XCTestCase {
    
    // Test that all keys return non-empty strings for both languages
    func testAllKeysHaveTranslations() {
        let allCases = [
            LocalizedKey.playButton,
            .solveButton,
            .backButton,
            .settingsTitle,
            .settingsGeneral,
            .settingsLanguage,
            .settingsColorScheme,
            .selectDifficulties,
            .difficultyLabel,
            .difficultyEasy,
            .difficultyMedium,
            .difficultyHard,
            .difficultyHardest,
            .handNumberPrefix,
            .helpTitle,
            .historyTitle,
            .historyEmpty,
            .historyLimitNote,
            .colorSchemeClassic,
            .colorSchemeBarbie,
            .colorSchemeHermes,
            .colorSchemeSeahawks,
            .colorSchemeBarcelona,
            .colorSchemeInterMilan,
            .colorSchemePSG,
            .colorSchemeLakers,
            .colorSchemeBocaJuniors,
            .settingsAppIcon,
            .settingsAppIconAutoChange
        ]
        
        for key in allCases {
            // Test English translations
            XCTAssertFalse(key.english.isEmpty, "English translation missing for \(String(describing: key))")
            
            // Test Chinese translations
            XCTAssertFalse(key.chinese.isEmpty, "Chinese translation missing for \(String(describing: key))")
            
            // Test that translations are different (no copy-paste errors)
            XCTAssertNotEqual(key.english, key.chinese, "English and Chinese translations are identical for \(String(describing: key))")
        }
    }
    
    // Test string retrieval for both languages
    func testStringRetrieval() {
        // Test English
        XCTAssertEqual(
            LocalizationResource.string(for: .playButton, language: .english),
            "Play"
        )
        XCTAssertEqual(
            LocalizationResource.string(for: .settingsTitle, language: .english),
            "Settings"
        )
        
        // Test Chinese
        XCTAssertEqual(
            LocalizationResource.string(for: .playButton, language: .chinese),
            "换一组"
        )
        XCTAssertEqual(
            LocalizationResource.string(for: .settingsTitle, language: .chinese),
            "设置"
        )
    }
    
    // Test that system language fallback works
    func testLanguageFallback() {
        // Test that system fallback to English works
        let systemLanguage = Language.auto
        let result = LocalizationResource.string(for: .playButton, language: systemLanguage)
        XCTAssertTrue(
            result == "Play" || result == "换一组",
            "System language should return either English or Chinese"
        )
    }
    
    // Test string format consistency
    func testStringFormatConsistency() {
        // Test that difficulty label has consistent spacing
        XCTAssertTrue(LocalizedKey.difficultyLabel.english.hasSuffix(" "))
        XCTAssertTrue(LocalizedKey.difficultyLabel.chinese.hasSuffix("："))
        
        // Test that hand number prefix has consistent spacing
        XCTAssertTrue(LocalizedKey.handNumberPrefix.english.hasSuffix(" "))
        XCTAssertTrue(LocalizedKey.handNumberPrefix.chinese.hasSuffix(" "))
    }
    
    // Test specific cases that might be problematic
    func testSpecificCases() {
        // Test that color scheme names are properly capitalized in English
        XCTAssertEqual(LocalizedKey.colorSchemeBarcelona.english, "Barcelona")
        XCTAssertEqual(LocalizedKey.colorSchemeInterMilan.english, "Inter Milan")
        XCTAssertEqual(LocalizedKey.colorSchemePSG.english, "PSG")
        
        // Test that history limit note has consistent format
        XCTAssertTrue(LocalizedKey.historyLimitNote.english.contains("20"))
        XCTAssertTrue(LocalizedKey.historyLimitNote.chinese.contains("20"))
    }
} 