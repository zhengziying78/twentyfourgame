import Foundation
import SwiftUI

enum Suit: String, CaseIterable {
    case spades = "♠️"
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
    
    var color: Color {
        switch self {
        case .hearts, .diamonds:
            return .red
        case .spades, .clubs:
            return .black
        }
    }
}

struct Card: Equatable, Identifiable {
    let id = UUID()
    let value: Int
    let suit: Suit
    
    var displayValue: String {
        switch value {
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "\(value)"
        }
    }
    
    var displayText: String {
        return "\(displayValue)\(suit.rawValue)"
    }
} 