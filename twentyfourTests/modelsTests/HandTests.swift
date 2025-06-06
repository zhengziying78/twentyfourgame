import XCTest
@testable import twentyfour

final class HandTests: XCTestCase {
    func testHandCreation() throws {
        let numbers = [1, 2, 3, 4]
        let solution = "1 + 2 + 3 + 4"
        let difficulty = Difficulty.easy
        let hand = try Hand(numbers: numbers, solution: solution, difficulty: difficulty)
        
        XCTAssertEqual(hand.cards.count, 4)
        XCTAssertEqual(hand.cards.map { $0.value }, numbers)
        XCTAssertEqual(hand.solution, solution)
        XCTAssertEqual(hand.difficulty, difficulty)
    }
    
    func testHandEvaluation() throws {
        let numbers = [5, 5, 5, 5]
        let solution = "5 + 5 + 5 + 5"
        let hand = try Hand(numbers: numbers, solution: solution, difficulty: .easy)
        
        XCTAssertEqual(hand.cards.count, 4)
        XCTAssertEqual(hand.cards.map { $0.value }, numbers)
        XCTAssertEqual(hand.solution, solution)
    }
    
    func testHandValidation() throws {
        // Test valid hand
        let validHand = try Hand(numbers: [1, 2, 3, 4], solution: "1 + 2 + 3 + 4", difficulty: .easy)
        XCTAssertNotNil(validHand)
        
        // Test hand with invalid number of cards
        XCTAssertThrowsError(try Hand(numbers: [1, 2, 3], solution: "1 + 2 + 3", difficulty: .easy)) { error in
            XCTAssertEqual(error as? HandError, HandError.invalidNumberOfCards)
        }
        
        // Test hand with valid numbers
        let validNumbersHand = try Hand(numbers: [1, 13, 11, 12], solution: "any", difficulty: .medium)
        XCTAssertTrue(validNumbersHand.cards.allSatisfy { $0.value >= 1 && $0.value <= 13 })
    }
    
    func testSuitAssignment() throws {
        // Test with different numbers
        let numbers = [1, 2, 3, 4]
        let hand = try Hand(numbers: numbers, solution: "", difficulty: .easy)
        
        // Each card should have a valid suit
        for card in hand.cards {
            XCTAssertTrue(Suit.allCases.contains(card.suit))
        }
        
        // Test with duplicate numbers
        let duplicateNumbers = [5, 5, 5, 5]
        let duplicateHand = try Hand(numbers: duplicateNumbers, solution: "", difficulty: .easy)
        
        // Each card should have a different suit when values are the same
        let suits = duplicateHand.cards.map { $0.suit }
        XCTAssertEqual(Set(suits).count, 4, "Cards with same value should have different suits")
    }
    
    func testHandEquality() throws {
        let hand1 = try Hand(numbers: [1, 2, 3, 4], solution: "1+2+3+4", difficulty: .easy)
        let hand2 = try Hand(numbers: [4, 3, 2, 1], solution: "4+3+2+1", difficulty: .medium)
        let hand3 = try Hand(numbers: [1, 2, 3, 5], solution: "1+2+3+5", difficulty: .easy)
        
        // Hands with same numbers in different order should be equal
        XCTAssertEqual(hand1, hand2)
        
        // Hands with different numbers should not be equal
        XCTAssertNotEqual(hand1, hand3)
        XCTAssertNotEqual(hand2, hand3)
    }
    
    func testDifficultyLevels() throws {
        // Test all difficulty levels can be used
        let difficulties: [Difficulty] = [.easy, .medium, .hard, .hardest]
        let numbers = [1, 2, 3, 4]
        
        for difficulty in difficulties {
            let hand = try Hand(numbers: numbers, solution: "", difficulty: difficulty)
            XCTAssertEqual(hand.difficulty, difficulty)
        }
    }
    
    func testRandomSuitAssignmentDistribution() throws {
        let numbers = [5, 5, 5, 5]
        var suitCounts: [Suit: Int] = [:]
        let iterations = 1000
        
        // Create many hands with the same numbers to test suit distribution
        for _ in 0..<iterations {
            let hand = try Hand(numbers: numbers, solution: "", difficulty: .easy)
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