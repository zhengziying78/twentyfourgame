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
        let numbers = [2, 4, 4, 7]
        let solution = "4 * 2 * (7 - 4) = 24"
        let hand = Hand(numbers: numbers, solution: solution)
        
        // Test that all cards are created
        XCTAssertEqual(hand.cards.count, 4)
        
        // Test that values are correct
        let values = hand.cards.map { $0.value }.sorted()
        XCTAssertEqual(values, numbers.sorted())
        
        // Test that solution is stored
        XCTAssertEqual(hand.solution, solution)
        
        // Test that suits are unique for same values
        let fourCards = hand.cards.filter { $0.value == 4 }
        XCTAssertEqual(fourCards.count, 2)
        XCTAssertNotEqual(fourCards[0].suit, fourCards[1].suit)
    }
    
    func testGameDataRandomHand() {
        let hand1 = GameData.shared.getRandomHand()
        XCTAssertNotNil(hand1)
        
        // Test that we can get multiple hands
        let hand2 = GameData.shared.getRandomHand()
        XCTAssertNotNil(hand2)
        
        // Test that hands are different (note: there's a small chance this could fail randomly)
        XCTAssertNotEqual(hand1?.cards.map { $0.value }, hand2?.cards.map { $0.value })
    }
    
    func testRecentHandsAvoidance() {
        var seenHands = Set<[Int]>()
        
        // Get 10 hands and verify they're different as much as possible
        for _ in 0..<10 {
            guard let hand = GameData.shared.getRandomHand() else {
                XCTFail("Failed to get hand")
                return
            }
            
            let values = hand.cards.map { $0.value }.sorted()
            seenHands.insert(values)
        }
        
        // We should have seen at least 3 different hands (given our dataset)
        XCTAssertGreaterThan(seenHands.count, 2)
    }
}
