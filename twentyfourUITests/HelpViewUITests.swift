import XCTest

final class HelpViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testHelpView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Open settings menu
        app.buttons["Settings"].tap()
        
        // Tap help button
        let helpButton = app.buttons["Help"]
        XCTAssertTrue(helpButton.exists)
        helpButton.tap()
        
        // Verify help content exists
        let helpText = app.staticTexts["How to Play"]
        XCTAssertTrue(helpText.exists)
        
        // Verify can dismiss help view
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        
        // Dismiss settings
        app.buttons["Done"].tap()
    }
} 