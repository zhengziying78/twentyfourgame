import XCTest
@testable import twentyfour

final class CardTests: XCTestCase {
    func testCardCreation() {
        let card = Card(value: 5, suit: .hearts)
        XCTAssertEqual(card.value, 5)
        XCTAssertEqual(card.suit, .hearts)
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
        let lightScheme = ColorScheme(primary: .black, secondary: .red)
        let darkScheme = ColorScheme(primary: .white, secondary: .red)
        
        // Test light scheme colors
        XCTAssertEqual(Suit.spades.color(scheme: lightScheme), lightScheme.primary)
        XCTAssertEqual(Suit.clubs.color(scheme: lightScheme), lightScheme.primary)
        XCTAssertEqual(Suit.hearts.color(scheme: lightScheme), lightScheme.secondary)
        XCTAssertEqual(Suit.diamonds.color(scheme: lightScheme), lightScheme.secondary)
        
        // Test dark scheme colors
        XCTAssertEqual(Suit.spades.color(scheme: darkScheme), darkScheme.primary)
        XCTAssertEqual(Suit.clubs.color(scheme: darkScheme), darkScheme.primary)
        XCTAssertEqual(Suit.hearts.color(scheme: darkScheme), darkScheme.secondary)
        XCTAssertEqual(Suit.diamonds.color(scheme: darkScheme), darkScheme.secondary)
    }
    
    func testCardEquality() {
        let card1 = Card(value: 5, suit: .hearts)
        let card2 = Card(value: 5, suit: .hearts)
        let card3 = Card(value: 5, suit: .spades)
        let card4 = Card(value: 6, suit: .hearts)
        
        // Test equality based on value and suit
        XCTAssertEqual(card1, card2)
        XCTAssertNotEqual(card1, card3)
        XCTAssertNotEqual(card1, card4)
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