import XCTest
@testable import twentyfour

final class HandTests: XCTestCase {
    func testHandCreation() {
        let numbers = [1, 2, 3, 4]
        let solution = "(1 + 2) × (3 + 4)"
        let difficulty = Difficulty.easy
        
        let hand = Hand(numbers: numbers, solution: solution, difficulty: difficulty)
        
        XCTAssertEqual(hand.cards.count, 4)
        XCTAssertEqual(hand.cards.map { $0.value }.sorted(), numbers.sorted())
        XCTAssertEqual(hand.solution, solution)
        XCTAssertEqual(hand.difficulty, difficulty)
    }
    
    func testSuitAssignment() {
        // Test with different numbers
        let numbers = [1, 2, 3, 4]
        let hand = Hand(numbers: numbers, solution: "", difficulty: .easy)
        
        // Each card should have a valid suit
        for card in hand.cards {
            XCTAssertTrue(Suit.allCases.contains(card.suit))
        }
        
        // Test with duplicate numbers
        let duplicateNumbers = [5, 5, 5, 5]
        let duplicateHand = Hand(numbers: duplicateNumbers, solution: "", difficulty: .easy)
        
        // Each card should have a different suit when values are the same
        let suits = duplicateHand.cards.map { $0.suit }
        XCTAssertEqual(Set(suits).count, 4, "Cards with same value should have different suits")
    }
    
    func testHandEquality() {
        let hand1 = Hand(numbers: [1, 2, 3, 4], solution: "1+2+3+4", difficulty: .easy)
        let hand2 = Hand(numbers: [4, 3, 2, 1], solution: "4+3+2+1", difficulty: .medium)
        let hand3 = Hand(numbers: [1, 2, 3, 5], solution: "1+2+3+5", difficulty: .easy)
        
        // Hands with same numbers in different order should be equal
        XCTAssertEqual(hand1, hand2)
        
        // Hands with different numbers should not be equal
        XCTAssertNotEqual(hand1, hand3)
        XCTAssertNotEqual(hand2, hand3)
    }
    
    func testDifficultyLevels() {
        // Test all difficulty levels can be used
        let difficulties: [Difficulty] = [.easy, .medium, .hard, .hardest]
        let numbers = [1, 2, 3, 4]
        
        for difficulty in difficulties {
            let hand = Hand(numbers: numbers, solution: "", difficulty: difficulty)
            XCTAssertEqual(hand.difficulty, difficulty)
        }
    }
    
    func testRandomSuitAssignmentDistribution() {
        let numbers = [5, 5, 5, 5]
        var suitCounts: [Suit: Int] = [:]
        let iterations = 1000
        
        // Create many hands with the same numbers to test suit distribution
        for _ in 0..<iterations {
            let hand = Hand(numbers: numbers, solution: "", difficulty: .easy)
            for card in hand.cards {
                suitCounts[card.suit, default: 0] += 1
            }
        }
        
        // Each suit should be used approximately equally
        let expectedCount = Double(iterations * 4) / Double(Suit.allCases.count)
        let tolerance = expectedCount * 0.2 // Allow 20% deviation
        
        for suit in Suit.allCases {
            let count = suitCounts[suit, default: 0]
            XCTAssertTrue(
                abs(Double(count) - expectedCount) < tolerance,
                "Suit \(suit) was used \(count) times, expected approximately \(Int(expectedCount))"
            )
        }
    }
} 