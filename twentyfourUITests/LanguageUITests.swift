import XCTest

final class LanguageUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLanguageSelector() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Open settings menu
        app.buttons["Settings"].tap()
        
        // Tap language button
        let languageButton = app.buttons["Language"]
        XCTAssertTrue(languageButton.exists)
        languageButton.tap()
        
        // Verify language options exist
        let englishOption = app.buttons["English"]
        XCTAssertTrue(englishOption.exists)
        englishOption.tap()
        
        // Dismiss language selector
        app.buttons["Done"].tap()
        
        // Dismiss settings
        app.buttons["Done"].tap()
    }
} 