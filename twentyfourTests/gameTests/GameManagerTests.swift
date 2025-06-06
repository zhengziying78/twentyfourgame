import XCTest
@testable import twentyfour

final class GameManagerTests: XCTestCase {
    var manager: GameManager!
    
    override func setUp() {
        super.setUp()
        manager = GameManager(dataset: HandDataset.shared, state: GameState())
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testSingletonPattern() {
        let instance1 = GameManager.shared
        let instance2 = GameManager.shared
        
        // Test singleton pattern
        XCTAssertTrue(instance1 === instance2, "GameManager should be a singleton")
        
        // Also verify that custom instances are different
        let customInstance1 = GameManager()
        let customInstance2 = GameManager()
        XCTAssertFalse(customInstance1 === customInstance2, "Custom instances should be different")
        XCTAssertFalse(customInstance1 === instance1, "Custom instance should be different from singleton")
    }
    
    func testInitialState() {
        // Test initial state
        XCTAssertNil(manager.currentHand, "Initial hand should be nil")
        XCTAssertEqual(manager.formattedSolution, "", "Initial formatted solution should be empty")
        XCTAssertNil(manager.handNumber, "Initial hand number should be nil")
    }
    
    func testHandNumberFormatting() {
        // Get a random hand
        manager.getRandomHand()
        
        // Test hand number formatting
        XCTAssertNotNil(manager.handNumber, "Hand number should not be nil after getting a random hand")
        if let number = manager.handNumber {
            XCTAssertGreaterThan(number, 0, "Hand number should be positive")
        }
    }
    
    func testFormattedSolutionConsistency() {
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