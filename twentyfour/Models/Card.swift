import Foundation
import SwiftUI

enum Suit: String, CaseIterable {
    case spades = "suit.spade.fill"
    case hearts = "suit.heart.fill"
    case diamonds = "suit.diamond.fill"
    case clubs = "suit.club.fill"
    
    func color(scheme: ColorScheme) -> Color {
        switch self {
        case .hearts, .diamonds:
            return scheme.secondary
        case .spades, .clubs:
            return scheme.primary
        }
    }
    
    var symbol: String { rawValue }
}

struct Card: Equatable, Identifiable {
    let id = UUID()
    let value: Int
    let suit: Suit
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value && lhs.suit == rhs.suit
    }
    
    var displayValue: String {
        switch value {
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "\(value)"
        }
    }
    
    var displayText: String {
        return "\(displayValue)\(suit.symbol)"
    }
} 