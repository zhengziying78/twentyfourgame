import XCTest

final class ColorThemeUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testColorSelector() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Open settings menu
        app.buttons["Settings"].tap()
        
        // Tap color theme button
        let colorButton = app.buttons["Color Theme"]
        XCTAssertTrue(colorButton.exists)
        colorButton.tap()
        
        // Verify color options exist
        let lightOption = app.buttons["Light"]
        XCTAssertTrue(lightOption.exists)
        lightOption.tap()
        
        let darkOption = app.buttons["Dark"]
        XCTAssertTrue(darkOption.exists)
        darkOption.tap()
        
        // Dismiss color selector
        app.buttons["Done"].tap()
        
        // Dismiss settings
        app.buttons["Done"].tap()
    }
} 