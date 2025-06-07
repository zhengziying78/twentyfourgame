import XCTest

final class SolutionViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testShowSolution() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap show solution button
        let showSolutionButton = app.buttons["Show Solution"]
        XCTAssertTrue(showSolutionButton.exists)
        showSolutionButton.tap()
        
        // Verify solution sheet appears
        let solutionSheet = app.sheets.firstMatch
        XCTAssertTrue(solutionSheet.exists)
        
        // Verify dismiss button exists and works
        let dismissButton = solutionSheet.buttons["Dismiss"].firstMatch
        XCTAssertTrue(dismissButton.exists)
        dismissButton.tap()
        
        // Verify sheet is dismissed
        XCTAssertFalse(solutionSheet.exists)
    }
} 