import XCTest
@testable import twentyfour

final class HandDatasetTests: XCTestCase {
    func testSingletonPattern() {
        let instance1 = HandDataset.shared
        let instance2 = HandDataset.shared
        
        XCTAssertTrue(instance1 === instance2, "HandDataset should be a singleton")
    }
    
    func testDatasetNotEmpty() {
        let dataset = HandDataset.shared
        XCTAssertFalse(dataset.hands.isEmpty, "Dataset should not be empty")
    }
    
    func testHandValidity() {
        let dataset = HandDataset.shared
        
        for hand in dataset.hands {
            // Test card count
            XCTAssertEqual(hand.cards.count, 4, "Each hand should have exactly 4 cards")
            
            // Test card values
            for card in hand.cards {
                XCTAssertGreaterThanOrEqual(card.value, 1, "Card value should be at least 1")
                XCTAssertLessThanOrEqual(card.value, 13, "Card value should be at most 13")
            }
            
            // Test solution exists
            XCTAssertFalse(hand.solution.isEmpty, "Hand should have a solution")
            
            // Test difficulty is set
            XCTAssertNotNil(hand.difficulty, "Hand should have a difficulty level")
        }
    }
    
    func testDifficultyDistribution() {
        let dataset = HandDataset.shared
        var difficultyCount: [Difficulty: Int] = [:]
        
        // Count hands by difficulty
        for hand in dataset.hands {
            difficultyCount[hand.difficulty, default: 0] += 1
        }
        
        // Verify all difficulty levels are represented
        XCTAssertGreaterThan(difficultyCount[.easy, default: 0], 0, "Should have easy hands")
        XCTAssertGreaterThan(difficultyCount[.medium, default: 0], 0, "Should have medium hands")
        XCTAssertGreaterThan(difficultyCount[.hard, default: 0], 0, "Should have hard hands")
        XCTAssertGreaterThan(difficultyCount[.hardest, default: 0], 0, "Should have hardest hands")
        
        // Print distribution for information
        print("Difficulty distribution:")
        for (difficulty, count) in difficultyCount.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
            print("\(difficulty): \(count) hands (\(Double(count) / Double(dataset.hands.count) * 100)%)")
        }
    }
    
    func testUniqueSolutions() {
        let dataset = HandDataset.shared
        var seenSolutions = Set<String>()
        
        for hand in dataset.hands {
            // Normalize solution by removing spaces and sorting numbers
            let normalizedSolution = hand.solution
                .replacingOccurrences(of: " ", with: "")
            
            XCTAssertFalse(seenSolutions.contains(normalizedSolution), 
                          "Duplicate solution found: \(normalizedSolution)")
            seenSolutions.insert(normalizedSolution)
        }
    }
    
    func testHandSorting() {
        let dataset = HandDataset.shared
        var previousNumbers: [Int]?
        
        for hand in dataset.hands {
            let currentNumbers = hand.cards.map { $0.value }.sorted()
            
            if let previous = previousNumbers {
                let comparison = zip(previous, currentNumbers)
                    .first(where: { $0.0 != $0.1 })
                    .map { $0.0 <= $0.1 } ?? true
                
                XCTAssertTrue(comparison, "Hands should be sorted by card values")
            }
            previousNumbers = currentNumbers
        }
    }
} 