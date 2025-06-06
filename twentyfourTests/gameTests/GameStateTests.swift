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
            Hand(numbers: [1, 2, 3, 4], 
                 solution: "(1+2)*(3+4)", 
                 difficulty: .hard)
        ]
        
        // Clear all difficulties except easy
        let preferences = FilterPreferences.shared
        for difficulty in Difficulty.allCases where difficulty != .easy {
            preferences.toggleDifficulty(difficulty)
        }
        
        // When
        gameState.getRandomHand(from: hands)
        
        // Then
        XCTAssertNil(gameState.currentHand)
        XCTAssertNil(gameState.currentHandIndex)
    }
    
    func testGetRandomHandSuccess() {
        // Given
        let hand = Hand(numbers: [1, 2, 3, 4],
                       solution: "(1+2)*(3+4)",
                       difficulty: .easy)
        let hands = [hand]
        
        // Ensure only easy difficulty is selected
        let preferences = FilterPreferences.shared
        for difficulty in Difficulty.allCases where difficulty != .easy {
            preferences.toggleDifficulty(difficulty)
        }
        
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
        let hand = Hand(numbers: [1, 2, 3, 4],
                       solution: "1*2/3+4",
                       difficulty: .easy)
        let hands = [hand]
        
        // Ensure only easy difficulty is selected
        let preferences = FilterPreferences.shared
        for difficulty in Difficulty.allCases where difficulty != .easy {
            preferences.toggleDifficulty(difficulty)
        }
        
        // When
        gameState.getRandomHand(from: hands)
        
        // Then
        XCTAssertEqual(gameState.formattedSolution, "1×2÷3+4")
    }
    
    func testRecentHandsLimit() {
        // Given
        let hands = (1...6).map { i in
            Hand(numbers: [i, i+1, i+2, i+3],
                 solution: "1+2+3+4",
                 difficulty: .easy)
        }
        
        // Ensure only easy difficulty is selected
        let preferences = FilterPreferences.shared
        for difficulty in Difficulty.allCases where difficulty != .easy {
            preferences.toggleDifficulty(difficulty)
        }
        
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