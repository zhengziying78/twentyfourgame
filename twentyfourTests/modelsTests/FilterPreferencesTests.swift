import XCTest
@testable import twentyfour

final class FilterPreferencesTests: XCTestCase {
    var userDefaults: UserDefaults!
    var preferences: FilterPreferences!
    let key = "selectedDifficulties"
    
    override func setUp() {
        super.setUp()
        // Use a unique suite name for testing to avoid interfering with actual app data
        userDefaults = UserDefaults(suiteName: "FilterPreferencesTests")!
        userDefaults.removePersistentDomain(forName: "FilterPreferencesTests")
        preferences = FilterPreferences.createForTesting(defaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "FilterPreferencesTests")
        userDefaults = nil
        preferences = nil
        super.tearDown()
    }
    
    func testSingletonPattern() {
        let instance1 = FilterPreferences.shared
        let instance2 = FilterPreferences.shared
        
        XCTAssertTrue(instance1 === instance2, "FilterPreferences should be a singleton")
        
        // Also verify that custom instances are different
        let customInstance1 = FilterPreferences.createForTesting(defaults: userDefaults)
        let customInstance2 = FilterPreferences.createForTesting(defaults: userDefaults)
        XCTAssertFalse(customInstance1 === customInstance2, "Custom instances should be different")
        XCTAssertFalse(customInstance1 === instance1, "Custom instance should be different from singleton")
    }
    
    func testInitialState() {
        // Should start with all difficulties selected
        XCTAssertEqual(
            preferences.selectedDifficulties,
            Set(Difficulty.allCases),
            "Should initialize with all difficulties selected"
        )
    }
    
    func testToggleDifficulty() {
        // Initially all difficulties are selected
        XCTAssertTrue(preferences.selectedDifficulties.contains(.easy))
        
        // Toggle off easy difficulty
        preferences.toggleDifficulty(.easy)
        XCTAssertFalse(preferences.selectedDifficulties.contains(.easy))
        XCTAssertTrue(preferences.selectedDifficulties.contains(.medium))
        XCTAssertTrue(preferences.selectedDifficulties.contains(.hard))
        XCTAssertTrue(preferences.selectedDifficulties.contains(.hardest))
        
        // Toggle it back on
        preferences.toggleDifficulty(.easy)
        XCTAssertTrue(preferences.selectedDifficulties.contains(.easy))
    }
    
    func testPreventEmptySelection() {
        // Try to deselect all difficulties one by one
        preferences.toggleDifficulty(.easy)
        preferences.toggleDifficulty(.medium)
        preferences.toggleDifficulty(.hard)
        
        // Try to deselect the last one
        preferences.toggleDifficulty(.hardest)
        
        // Should still have one difficulty selected
        XCTAssertEqual(preferences.selectedDifficulties.count, 1)
        XCTAssertTrue(preferences.selectedDifficulties.contains(.hardest))
    }
    
    func testPersistence() {
        // Toggle some difficulties
        preferences.toggleDifficulty(.easy)
        preferences.toggleDifficulty(.medium)
        
        // Create a new instance to test loading from disk
        let newPreferences = FilterPreferences.createForTesting(defaults: userDefaults)
        
        // Should have the same selections
        XCTAssertEqual(preferences.selectedDifficulties, newPreferences.selectedDifficulties)
        XCTAssertFalse(newPreferences.selectedDifficulties.contains(.easy))
        XCTAssertFalse(newPreferences.selectedDifficulties.contains(.medium))
        XCTAssertTrue(newPreferences.selectedDifficulties.contains(.hard))
        XCTAssertTrue(newPreferences.selectedDifficulties.contains(.hardest))
    }
    
    func testInvalidPersistedData() {
        // Save invalid data
        userDefaults.set(["invalid_difficulty"], forKey: key)
        userDefaults.synchronize()
        
        // Create a new instance
        let newPreferences = FilterPreferences.createForTesting(defaults: userDefaults)
        
        // Should fall back to default (all difficulties)
        XCTAssertEqual(
            newPreferences.selectedDifficulties,
            Set(Difficulty.allCases),
            "Should fall back to all difficulties when saved data is invalid"
        )
    }
} 