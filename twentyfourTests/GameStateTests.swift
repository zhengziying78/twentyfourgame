import XCTest
@testable import twentyfour

final class GameStateTests: XCTestCase {
    var gameState: GameState!
    
    override func setUp() {
        super.setUp()
        gameState = GameState()
    }
    
    override func tearDown() {
        gameState = nil
        super.tearDown()
    }
    
    func testGetRandomHandWithEmptyHands() {
        // Given
        let emptyHands: [Hand] = []
        
        // When
        gameState.getRandomHand(from: emptyHands)
        
        // Then
        XCTAssertNil(gameState.currentHand)
        XCTAssertNil(gameState.currentHandIndex)
    }
    
    func testGetRandomHandWithFilteredHandsEmpty() {
        // Given
        let hands = [
            Hand(cards: [Card(value: 1), Card(value: 2), Card(value: 3), Card(value: 4)], 
                 solution: "(1+2)*(3+4)", 
                 difficulty: .hard)
        ]
        FilterPreferences.shared.selectedDifficulties = [.easy] // Only easy selected
        
        // When
        gameState.getRandomHand(from: hands)
        
        // Then
        XCTAssertNil(gameState.currentHand)
        XCTAssertNil(gameState.currentHandIndex)
    }
    
    func testGetRandomHandSuccess() {
        // Given
        let hand = Hand(cards: [Card(value: 1), Card(value: 2), Card(value: 3), Card(value: 4)],
                       solution: "(1+2)*(3+4)",
                       difficulty: .easy)
        let hands = [hand]
        FilterPreferences.shared.selectedDifficulties = [.easy]
        
        // When
        gameState.getRandomHand(from: hands)
        
        // Then
        XCTAssertNotNil(gameState.currentHand)
        XCTAssertEqual(gameState.currentHandIndex, 0)
        XCTAssertEqual(gameState.currentHand?.cards.map { $0.value }.sorted(),
                      hand.cards.map { $0.value }.sorted())
    }
    
    func testFormattedSolution() {
        // Given
        let hand = Hand(cards: [Card(value: 1), Card(value: 2), Card(value: 3), Card(value: 4)],
                       solution: "1*2/3+4",
                       difficulty: .easy)
        let hands = [hand]
        FilterPreferences.shared.selectedDifficulties = [.easy]
        
        // When
        gameState.getRandomHand(from: hands)
        
        // Then
        XCTAssertEqual(gameState.formattedSolution, "1×2÷3+4")
    }
    
    func testRecentHandsLimit() {
        // Given
        let hands = (1...6).map { i in
            Hand(cards: [Card(value: i), Card(value: i+1), Card(value: i+2), Card(value: i+3)],
                 solution: "1+2+3+4",
                 difficulty: .easy)
        }
        FilterPreferences.shared.selectedDifficulties = [.easy]
        
        // When
        for _ in 1...6 {
            gameState.getRandomHand(from: hands)
        }
        
        // Then
        // Get a new hand - it should be possible because we maintain only 5 recent hands
        gameState.getRandomHand(from: hands)
        XCTAssertNotNil(gameState.currentHand)
    }
} 