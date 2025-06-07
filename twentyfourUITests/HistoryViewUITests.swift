import XCTest

final class HistoryViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testHistoryView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Open history view
        let historyButton = app.buttons["History"]
        XCTAssertTrue(historyButton.exists)
        historyButton.tap()
        
        // Verify history list exists
        let historyList = app.collectionViews["historyList"]
        XCTAssertTrue(historyList.exists)
        
        // Verify can dismiss history view
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
    }
} 