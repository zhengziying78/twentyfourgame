import XCTest
@testable import twentyfour

final class GameManagerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        GameManager.shared.reset()
    }
    
    override func tearDown() {
        GameManager.shared.reset()
        super.tearDown()
    }
    
    func testSingletonPattern() {
        let instance1 = GameManager.shared
        let instance2 = GameManager.shared
        
        // Test singleton pattern
        XCTAssertTrue(instance1 === instance2, "GameManager should be a singleton")
    }
    
    func testInitialState() {
        let manager = GameManager.shared
        
        // Test initial state
        XCTAssertNil(manager.currentHand, "Initial hand should be nil")
        XCTAssertEqual(manager.formattedSolution, "", "Initial formatted solution should be empty")
        XCTAssertNil(manager.handNumber, "Initial hand number should be nil")
    }
    
    func testHandNumberFormatting() {
        let manager = GameManager.shared
        
        // Get a random hand
        manager.getRandomHand()
        
        // Test hand number formatting
        XCTAssertNotNil(manager.handNumber, "Hand number should not be nil after getting a random hand")
        if let number = manager.handNumber {
            XCTAssertGreaterThan(number, 0, "Hand number should be positive")
        }
    }
    
    func testFormattedSolutionConsistency() {
        let manager = GameManager.shared
        
        // Get multiple random hands and verify solution formatting
        for _ in 1...5 {
            manager.getRandomHand()
            
            if let hand = manager.currentHand {
                let formattedSolution = manager.formattedSolution
                XCTAssertFalse(formattedSolution.contains("*"), "Solution should not contain '*'")
                XCTAssertFalse(formattedSolution.contains("/"), "Solution should not contain '/'")
                
                // Verify the solution matches the hand's solution after formatting
                let expectedSolution = hand.solution
                    .replacingOccurrences(of: "*", with: "×")
                    .replacingOccurrences(of: "/", with: "÷")
                XCTAssertEqual(formattedSolution, expectedSolution, "Formatted solution should match hand's solution")
            }
        }
    }
} 