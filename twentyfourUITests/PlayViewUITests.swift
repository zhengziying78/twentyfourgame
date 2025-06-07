import XCTest

final class PlayViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testPlayViewBasicElements() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify main UI elements exist
        XCTAssertTrue(app.staticTexts["Target: 24"].exists)
        XCTAssertTrue(app.buttons["New Game"].exists)
        XCTAssertTrue(app.buttons["Show Solution"].exists)
        XCTAssertTrue(app.buttons["Clear"].exists)
    }
    
    @MainActor
    func testPlayViewNumberInteraction() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Find and tap the first number button
        let firstNumberButton = app.buttons.matching(identifier: "numberButton").firstMatch
        XCTAssertTrue(firstNumberButton.exists)
        firstNumberButton.tap()
        
        // Verify the number appears in the expression field
        let expressionText = app.staticTexts.matching(identifier: "expressionText").firstMatch
        XCTAssertTrue(expressionText.exists)
        XCTAssertFalse(expressionText.label.isEmpty)
    }
} 