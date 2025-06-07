import XCTest

final class DifficultyUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testDifficultySelector() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Open settings menu
        app.buttons["Settings"].tap()
        
        // Tap difficulty button
        let difficultyButton = app.buttons["Difficulty"]
        XCTAssertTrue(difficultyButton.exists)
        difficultyButton.tap()
        
        // Verify difficulty options exist and can be selected
        let easyOption = app.buttons["Easy"]
        XCTAssertTrue(easyOption.exists)
        easyOption.tap()
        
        let hardOption = app.buttons["Hard"]
        XCTAssertTrue(hardOption.exists)
        hardOption.tap()
        
        // Dismiss difficulty selector
        app.buttons["Done"].tap()
        
        // Dismiss settings
        app.buttons["Done"].tap()
    }
} 