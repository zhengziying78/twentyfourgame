import XCTest
@testable import twentyfour

final class ColorSchemeManagerTests: XCTestCase {
    var userDefaults: UserDefaults!
    var manager: ColorSchemeManager!
    let testKey = "selectedColorScheme"
    
    override func setUp() {
        super.setUp()
        // Use a unique suite name for testing to avoid interfering with actual app data
        userDefaults = UserDefaults(suiteName: "ColorSchemeManagerTests")!
        userDefaults.removePersistentDomain(forName: "ColorSchemeManagerTests")
        manager = ColorSchemeManager.createForTesting(defaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "ColorSchemeManagerTests")
        userDefaults = nil
        manager = nil
        super.tearDown()
    }
    
    func testSingletonPattern() {
        let instance1 = ColorSchemeManager.shared
        let instance2 = ColorSchemeManager.shared
        
        XCTAssertTrue(instance1 === instance2, "ColorSchemeManager should be a singleton")
    }
    
    func testDefaultSchemeInitialization() {
        // Clear any existing saved scheme
        userDefaults.removeObject(forKey: testKey)
        
        // Create a new manager instance to test initialization
        let testManager = ColorSchemeManager.createForTesting(defaults: userDefaults)
        XCTAssertEqual(testManager.currentScheme, .classic, "Default scheme should be classic")
    }
    
    func testSchemeSettingAndPersistence() {
        // Test setting each available scheme
        for scheme in ColorScheme.allCases {
            manager.setScheme(scheme)
            XCTAssertEqual(manager.currentScheme, scheme, "Current scheme should match set scheme")
            
            // Verify persistence in UserDefaults
            let savedScheme = userDefaults.string(forKey: testKey)
            XCTAssertEqual(savedScheme, scheme.rawValue, "Scheme should be saved to UserDefaults")
        }
    }
    
    func testLoadingSavedScheme() {
        // Save a scheme to UserDefaults
        userDefaults.set(ColorScheme.barbie.rawValue, forKey: testKey)
        userDefaults.synchronize()
        
        // Create a new instance which should load the saved scheme
        let testManager = ColorSchemeManager.createForTesting(defaults: userDefaults)
        XCTAssertEqual(testManager.currentScheme, .barbie, "Manager should load saved scheme from UserDefaults")
    }
    
    func testInvalidSavedScheme() {
        // Save an invalid scheme value
        userDefaults.set("invalidScheme", forKey: testKey)
        userDefaults.synchronize()
        
        // Create a new instance which should fall back to classic
        let testManager = ColorSchemeManager.createForTesting(defaults: userDefaults)
        XCTAssertEqual(testManager.currentScheme, .classic, "Manager should use classic scheme when saved value is invalid")
    }
} 