import XCTest
@testable import twentyfour

final class HistoryTests: XCTestCase {
    var historyManager: HistoryManager!
    
    override func setUp() {
        super.setUp()
        historyManager = HistoryManager.shared
        historyManager.entries.removeAll()
    }
    
    func testHistoryEntryCreation() {
        let cards = [
            Card(value: 1, suit: .hearts),
            Card(value: 2, suit: .spades),
            Card(value: 3, suit: .diamonds),
            Card(value: 4, suit: .clubs)
        ]
        
        let entry = HistoryEntry(
            handNumber: 1,
            cards: cards,
            difficulty: .easy,
            solution: "1+2+3+4"
        )
        
        XCTAssertEqual(entry.handNumber, 1)
        XCTAssertEqual(entry.cards.count, 4)
        XCTAssertEqual(entry.difficulty, .easy)
        XCTAssertEqual(entry.solution, "1+2+3+4")
    }
    
    func testHistoryEntryEquality() {
        let cards = [Card(value: 1, suit: .hearts)]
        
        let entry1 = HistoryEntry(handNumber: 1, cards: cards, difficulty: .easy, solution: "")
        let entry2 = HistoryEntry(handNumber: 1, cards: cards, difficulty: .easy, solution: "")
        let entry3 = HistoryEntry(handNumber: 2, cards: cards, difficulty: .easy, solution: "")
        
        // Entries with different IDs should not be equal, even if other properties are the same
        XCTAssertNotEqual(entry1, entry2)
        XCTAssertNotEqual(entry1, entry3)
        XCTAssertNotEqual(entry2, entry3)
        
        // Entry should be equal to itself
        XCTAssertEqual(entry1, entry1)
    }
    
    func testSingletonPattern() {
        let instance1 = HistoryManager.shared
        let instance2 = HistoryManager.shared
        
        XCTAssertTrue(instance1 === instance2, "HistoryManager should be a singleton")
    }
    
    func testAddEntry() {
        let cards = [
            Card(value: 1, suit: .hearts),
            Card(value: 2, suit: .spades),
            Card(value: 3, suit: .diamonds),
            Card(value: 4, suit: .clubs)
        ]
        
        // Add first entry
        historyManager.addEntry(handNumber: 1, cards: cards, difficulty: .easy, solution: "1+2+3+4")
        
        XCTAssertEqual(historyManager.entries.count, 1)
        XCTAssertEqual(historyManager.totalHandsCount, 1)
        
        let firstEntry = historyManager.entries[0]
        XCTAssertEqual(firstEntry.handNumber, 1)
        XCTAssertEqual(firstEntry.cards.count, 4)
        XCTAssertEqual(firstEntry.difficulty, .easy)
        XCTAssertEqual(firstEntry.solution, "1+2+3+4")
    }
    
    func testMaxEntriesLimit() {
        let cards = [Card(value: 1, suit: .hearts)]
        let maxEntries = 20 // This should match the private maxEntries in HistoryManager
        
        // Add more than maxEntries entries
        for i in 1...maxEntries + 5 {
            historyManager.addEntry(handNumber: i, cards: cards, difficulty: .easy, solution: "")
        }
        
        // Check that only maxEntries are kept
        XCTAssertEqual(historyManager.entries.count, maxEntries)
        
        // Check that the most recent entries are kept
        XCTAssertEqual(historyManager.entries[0].handNumber, maxEntries + 5)
        XCTAssertEqual(historyManager.entries[maxEntries - 1].handNumber, 6)
        
        // Total count should still increment
        XCTAssertEqual(historyManager.totalHandsCount, maxEntries + 5)
    }
    
    func testEntryOrder() {
        let cards = [Card(value: 1, suit: .hearts)]
        
        // Add multiple entries
        for i in 1...5 {
            historyManager.addEntry(handNumber: i, cards: cards, difficulty: .easy, solution: "")
        }
        
        // Check that entries are in reverse order (newest first)
        for i in 0..<5 {
            XCTAssertEqual(historyManager.entries[i].handNumber, 5 - i)
        }
    }
} 