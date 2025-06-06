import XCTest
@testable import twentyfour

final class GameStateTests: XCTestCase {
    var state: GameState!
    
    override func setUp() {
        super.setUp()
        state = GameState()
    }
    
    override func tearDown() {
        state = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNil(state.currentHand)
        XCTAssertNil(state.currentHandIndex)
        XCTAssertEqual(state.formattedSolution, "")
    }
    
    func testGetRandomHandWithEmptyHands() {
        // Given
        let emptyHands: [Hand] = []
        
        // When
        state.getRandomHand(from: emptyHands)
        
        // Then
        XCTAssertNil(state.currentHand)
        XCTAssertNil(state.currentHandIndex)
    }
    
    func testGetRandomHandWithFilteredHandsEmpty() throws {
        // Given
        let hand = try Hand(numbers: [1, 2, 3, 4], 
                      solution: "(1+2)*(3+4)", 
                      difficulty: .hard)
        let hands = [hand]
        
        // Clear all difficulties except easy
        let preferences = FilterPreferences.shared
        for difficulty in Difficulty.allCases where difficulty != .easy {
            preferences.toggleDifficulty(difficulty)
        }
        
        // When
        state.getRandomHand(from: hands)
        
        // Then
        XCTAssertNil(state.currentHand)
        XCTAssertNil(state.currentHandIndex)
    }
    
    func testGetRandomHandSuccess() throws {
        // Given
        let hand = try Hand(numbers: [1, 2, 3, 4],
                      solution: "(1+2)*(3+4)",
                      difficulty: .easy)
        let hands = [hand]
        
        // Ensure only easy difficulty is selected
        let preferences = FilterPreferences.shared
        for difficulty in Difficulty.allCases where difficulty != .easy {
            preferences.toggleDifficulty(difficulty)
        }
        preferences.toggleDifficulty(.easy) // Make sure easy is selected
        
        // When
        state.getRandomHand(from: hands)
        
        // Then
        XCTAssertNotNil(state.currentHand)
        XCTAssertEqual(state.currentHandIndex, 0)
        XCTAssertEqual(state.currentHand?.cards.map { $0.value }.sorted(),
                      hand.cards.map { $0.value }.sorted())
    }
    
    func testFormattedSolution() throws {
        // Given
        let hand = try Hand(numbers: [1, 2, 3, 4],
                      solution: "1*2/3+4",
                      difficulty: .easy)
        let hands = [hand]
        
        // Ensure only easy difficulty is selected
        let preferences = FilterPreferences.shared
        for difficulty in Difficulty.allCases where difficulty != .easy {
            preferences.toggleDifficulty(difficulty)
        }
        preferences.toggleDifficulty(.easy) // Make sure easy is selected
        
        // When
        state.getRandomHand(from: hands)
        
        // Then
        XCTAssertEqual(state.formattedSolution, "1×2÷3+4")
    }
    
    func testRecentHandsLimit() throws {
        // Given
        let hands = try (1...6).map { i in
            try Hand(numbers: [i, i+1, i+2, i+3],
                    solution: "1+2+3+4",
                    difficulty: .easy)
        }
        
        // Ensure only easy difficulty is selected
        let preferences = FilterPreferences.shared
        for difficulty in Difficulty.allCases where difficulty != .easy {
            preferences.toggleDifficulty(difficulty)
        }
        preferences.toggleDifficulty(.easy) // Make sure easy is selected
        
        // When
        for _ in 1...6 {
            state.getRandomHand(from: hands)
        }
        
        // Then
        // Get a new hand - it should be possible because we maintain only 5 recent hands
        state.getRandomHand(from: hands)
        XCTAssertNotNil(state.currentHand)
    }
} 