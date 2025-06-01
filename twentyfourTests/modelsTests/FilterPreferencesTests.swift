import XCTest
@testable import twentyfour

final class FilterPreferencesTests: XCTestCase {
    var preferences: FilterPreferences!
    let defaults = UserDefaults.standard
    let key = "selectedDifficulties"
    
    override func setUp() {
        super.setUp()
        // Clear any existing preferences
        defaults.removeObject(forKey: key)
        preferences = FilterPreferences.shared
    }
    
    override func tearDown() {
        // Clean up after each test
        defaults.removeObject(forKey: key)
        super.tearDown()
    }
    
    func testSingletonPattern() {
        let instance1 = FilterPreferences.shared
        let instance2 = FilterPreferences.shared
        
        XCTAssertTrue(instance1 === instance2, "FilterPreferences should be a singleton")
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
        let newPreferences = FilterPreferences.shared
        
        // Should have the same selections
        XCTAssertEqual(preferences.selectedDifficulties, newPreferences.selectedDifficulties)
        XCTAssertFalse(newPreferences.selectedDifficulties.contains(.easy))
        XCTAssertFalse(newPreferences.selectedDifficulties.contains(.medium))
        XCTAssertTrue(newPreferences.selectedDifficulties.contains(.hard))
        XCTAssertTrue(newPreferences.selectedDifficulties.contains(.hardest))
    }
    
    func testInvalidPersistedData() {
        // Save invalid data
        defaults.set(["invalid_difficulty"], forKey: key)
        
        // Create a new instance
        let newPreferences = FilterPreferences.shared
        
        // Should fall back to default (all difficulties)
        XCTAssertEqual(
            newPreferences.selectedDifficulties,
            Set(Difficulty.allCases),
            "Should fall back to all difficulties when saved data is invalid"
        )
    }
} 