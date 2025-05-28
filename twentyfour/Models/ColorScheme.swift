import SwiftUI

enum ColorScheme: String, CaseIterable, Identifiable {
    case classic
    case ocean
    case forest
    case sunset
    
    var id: String { rawValue }
    
    var localizedKey: LocalizedKey {
        switch self {
        case .classic: return .colorSchemeClassic
        case .ocean: return .colorSchemeOcean
        case .forest: return .colorSchemeForest
        case .sunset: return .colorSchemeSunset
        }
    }
    
    func localizedName(language: Language) -> String {
        return LocalizationResource.string(for: localizedKey, language: language)
    }
    
    var primary: Color {
        switch self {
        case .classic: return Color(white: 0.2) // Soft black
        case .ocean: return Color(red: 0.0, green: 0.2, blue: 0.4) // Navy
        case .forest: return Color(red: 0.1, green: 0.3, blue: 0.2) // Deep forest green
        case .sunset: return Color(red: 0.3, green: 0.1, blue: 0.3) // Deep purple
        }
    }
    
    var secondary: Color {
        switch self {
        case .classic: return Color(red: 0.87, green: 0.27, blue: 0.27) // Soft red
        case .ocean: return Color(red: 0.2, green: 0.5, blue: 0.5) // Teal
        case .forest: return Color(red: 0.5, green: 0.6, blue: 0.5) // Sage
        case .sunset: return Color(red: 0.9, green: 0.4, blue: 0.3) // Coral
        }
    }
    
    var textAndIcon: Color {
        switch self {
        case .classic, .ocean, .forest, .sunset:
            return .white.opacity(0.9) // All schemes use semi-transparent white for good contrast
        }
    }
    
    var disabledBackground: Color {
        return .gray // Common gray for disabled state across all schemes
    }
} 