import XCTest
@testable import twentyfour

final class CardTests: XCTestCase {
    func testCardDisplay() {
        let card = Card(value: 11, suit: .hearts)
        XCTAssertEqual(card.displayValue, "J")
        XCTAssertEqual(card.displayText, "Jsuit.heart.fill")
        
        let card2 = Card(value: 5, suit: .spades)
        XCTAssertEqual(card2.displayValue, "5")
        XCTAssertEqual(card2.displayText, "5suit.spade.fill")
    }
    
    func testCardCreation() {
        // Test regular number card
        let numberCard = Card(value: 7, suit: .diamonds)
        XCTAssertEqual(numberCard.value, 7)
        XCTAssertEqual(numberCard.suit, .diamonds)
        XCTAssertEqual(numberCard.displayValue, "7")
        
        // Test face cards
        let jackCard = Card(value: 11, suit: .clubs)
        XCTAssertEqual(jackCard.displayValue, "J")
        
        let queenCard = Card(value: 12, suit: .hearts)
        XCTAssertEqual(queenCard.displayValue, "Q")
        
        let kingCard = Card(value: 13, suit: .spades)
        XCTAssertEqual(kingCard.displayValue, "K")
    }
    
    func testCardEquality() {
        let card1 = Card(value: 10, suit: .hearts)
        let card2 = Card(value: 10, suit: .hearts)
        let card3 = Card(value: 10, suit: .diamonds)
        
        XCTAssertEqual(card1, card2, "Cards with same value and suit should be equal")
        XCTAssertNotEqual(card1, card3, "Cards with same value but different suits should not be equal")
    }
    
    func testCardDisplayValue() {
        // Test numeric values
        for value in 1...10 {
            let card = Card(value: value, suit: .spades)
            XCTAssertEqual(card.displayValue, "\(value)")
        }
        
        // Test face cards
        let jack = Card(value: 11, suit: .hearts)
        XCTAssertEqual(jack.displayValue, "J")
        
        let queen = Card(value: 12, suit: .diamonds)
        XCTAssertEqual(queen.displayValue, "Q")
        
        let king = Card(value: 13, suit: .clubs)
        XCTAssertEqual(king.displayValue, "K")
    }
    
    func testSuitSymbols() {
        XCTAssertEqual(Suit.spades.symbol, "suit.spade.fill")
        XCTAssertEqual(Suit.hearts.symbol, "suit.heart.fill")
        XCTAssertEqual(Suit.diamonds.symbol, "suit.diamond.fill")
        XCTAssertEqual(Suit.clubs.symbol, "suit.club.fill")
    }
    
    func testSuitColors() {
        // Use actual ColorScheme cases instead of custom ones
        let classicScheme = ColorScheme.classic  // black primary, red secondary
        let hermesScheme = ColorScheme.hermes    // black primary, orange secondary
        
        // Test classic scheme colors
        XCTAssertEqual(Suit.spades.color(scheme: classicScheme), classicScheme.primary)
        XCTAssertEqual(Suit.clubs.color(scheme: classicScheme), classicScheme.primary)
        XCTAssertEqual(Suit.hearts.color(scheme: classicScheme), classicScheme.secondary)
        XCTAssertEqual(Suit.diamonds.color(scheme: classicScheme), classicScheme.secondary)
        
        // Test hermes scheme colors
        XCTAssertEqual(Suit.spades.color(scheme: hermesScheme), hermesScheme.primary)
        XCTAssertEqual(Suit.clubs.color(scheme: hermesScheme), hermesScheme.primary)
        XCTAssertEqual(Suit.hearts.color(scheme: hermesScheme), hermesScheme.secondary)
        XCTAssertEqual(Suit.diamonds.color(scheme: hermesScheme), hermesScheme.secondary)
    }
    
    func testCardDisplayText() {
        let card1 = Card(value: 5, suit: .hearts)
        XCTAssertEqual(card1.displayText, "5suit.heart.fill")
        
        let card2 = Card(value: 11, suit: .spades)
        XCTAssertEqual(card2.displayText, "Jsuit.spade.fill")
        
        let card3 = Card(value: 12, suit: .diamonds)
        XCTAssertEqual(card3.displayText, "Qsuit.diamond.fill")
        
        let card4 = Card(value: 13, suit: .clubs)
        XCTAssertEqual(card4.displayText, "Ksuit.club.fill")
    }
} 