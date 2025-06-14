import Foundation

enum Difficulty: Int, CaseIterable, Hashable {
    case easy = 1
    case medium = 2
    case hard = 3
    case hardest = 4
}

enum HandError: Error {
    case invalidNumberOfCards
}

struct Hand: Equatable, Identifiable {
    let id = UUID()
    let cards: [Card]
    let solution: String
    let difficulty: Difficulty
    
    init(numbers: [Int], solution: String, difficulty: Difficulty) throws {
        guard numbers.count == 4 else {
            throw HandError.invalidNumberOfCards
        }
        
        // Randomly assign suits ensuring no duplicates for same values
        var availableSuits = Array(repeating: Suit.allCases, count: 4)
        
        self.cards = numbers.enumerated().map { index, value in
            let suitIndex = Int.random(in: 0..<availableSuits[index].count)
            let suit = availableSuits[index][suitIndex]
            
            // Remove the used suit from available suits for same value cards
            for i in (index + 1)..<4 where numbers[i] == value {
                availableSuits[i].removeAll { $0 == suit }
            }
            
            return Card(value: value, suit: suit)
        }
        
        self.solution = solution
        self.difficulty = difficulty
    }
    
    static func == (lhs: Hand, rhs: Hand) -> Bool {
        return lhs.cards.map { $0.value }.sorted() == rhs.cards.map { $0.value }.sorted()
    }
} 