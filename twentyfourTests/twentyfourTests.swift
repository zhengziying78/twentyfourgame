//
//  twentyfourTests.swift
//  twentyfourTests
//
//  Created by Ziying Zheng on 5/23/25.
//

import XCTest
@testable import twentyfour

final class TwentyFourTests: XCTestCase {
    
    func testCardDisplay() {
        let card = Card(value: 11, suit: .hearts)
        XCTAssertEqual(card.displayValue, "J")
        XCTAssertEqual(card.displayText, "J♥️")
        
        let card2 = Card(value: 5, suit: .spades)
        XCTAssertEqual(card2.displayValue, "5")
        XCTAssertEqual(card2.displayText, "5♠️")
    }
    
    func testHandCreation() {
        let numbers = [1, 2, 3, 4]
        let solution = "1 + 2 + 3 + 4"
        let difficulty = Difficulty.easy
        let hand = Hand(numbers: numbers, solution: solution, difficulty: difficulty)
        
        XCTAssertEqual(hand.cards.count, 4)
        XCTAssertEqual(hand.cards.map { $0.value }, numbers)
        XCTAssertEqual(hand.solution, solution)
        XCTAssertEqual(hand.difficulty, difficulty)
    }
    
    func testHandEvaluation() {
        let numbers = [5, 5, 5, 5]
        let solution = "5 + 5 + 5 + 5"
        let hand = Hand(numbers: numbers, solution: solution, difficulty: .easy)
        
        XCTAssertEqual(hand.cards.count, 4)
        XCTAssertEqual(hand.cards.map { $0.value }, numbers)
        XCTAssertEqual(hand.solution, solution)
    }
    
    func testRandomHandGeneration() {
        let gameData = GameData.shared
        
        gameData.getRandomHand()
        let hand1 = gameData.currentHand
        XCTAssertNotNil(hand1)
        XCTAssertEqual(hand1?.cards.count, 4)
        
        gameData.getRandomHand()
        let hand2 = gameData.currentHand
        XCTAssertNotNil(hand2)
        XCTAssertEqual(hand2?.cards.count, 4)
        
        // Test that we get different hands
        XCTAssertNotEqual(hand1?.cards.map { $0.value }, hand2?.cards.map { $0.value })
    }
    
    func testMultipleRandomHands() {
        var uniqueHands = Set<[Int]>()
        let gameData = GameData.shared
        
        // Generate 10 random hands and verify they're all valid
        for _ in 0..<10 {
            gameData.getRandomHand()
            guard let hand = gameData.currentHand else {
                XCTFail("Failed to generate random hand")
                return
            }
            
            let values = hand.cards.map { $0.value }.sorted()
            uniqueHands.insert(values)
            
            // Verify each hand has 4 cards
            XCTAssertEqual(hand.cards.count, 4)
            
            // Verify all numbers are between 1 and 13
            XCTAssertTrue(hand.cards.allSatisfy { $0.value >= 1 && $0.value <= 13 })
        }
        
        // Verify we got some different hands (at least 3 unique hands out of 10)
        XCTAssertGreaterThan(uniqueHands.count, 3)
    }
}
