import XCTest
@testable import twentyfour

final class ColorSchemeManagerTests: XCTestCase {
    var userDefaults: UserDefaults!
    let testKey = "selectedColorScheme"
    
    override func setUp() {
        super.setUp()
        // Use a unique suite name for testing to avoid interfering with actual app data
        userDefaults = UserDefaults(suiteName: "ColorSchemeManagerTests")!
        userDefaults.removePersistentDomain(forName: "ColorSchemeManagerTests")
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "ColorSchemeManagerTests")
        userDefaults = nil
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
        
        let manager = ColorSchemeManager.shared
        XCTAssertEqual(manager.currentScheme, .classic, "Default scheme should be classic")
    }
    
    func testSchemeSettingAndPersistence() {
        let manager = ColorSchemeManager.shared
        
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
        let manager = ColorSchemeManager.shared
        XCTAssertEqual(manager.currentScheme, .barbie, "Manager should load saved scheme from UserDefaults")
    }
    
    func testInvalidSavedScheme() {
        // Save an invalid scheme value
        userDefaults.set("invalidScheme", forKey: testKey)
        userDefaults.synchronize()
        
        // Create a new instance which should fall back to classic
        let manager = ColorSchemeManager.shared
        XCTAssertEqual(manager.currentScheme, .classic, "Manager should use classic scheme when saved value is invalid")
    }
} 