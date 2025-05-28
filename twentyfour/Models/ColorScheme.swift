import SwiftUI

enum ColorScheme: String, CaseIterable, Identifiable {
    case classic
    case grass
    case barbie
    case hermes
    
    var id: String { rawValue }
    
    var localizedKey: LocalizedKey {
        switch self {
        case .classic: return .colorSchemeClassic
        case .grass: return .colorSchemeGrass
        case .barbie: return .colorSchemeBarbie
        case .hermes: return .colorSchemeHermes
        }
    }
    
    func localizedName(language: Language) -> String {
        return LocalizationResource.string(for: localizedKey, language: language)
    }
    
    var primary: Color {
        switch self {
        case .classic: return Color(white: 0.15) // Soft black
        case .grass: return Color(red: 0x39/255, green: 0x50/255, blue: 0x62/255) // #395062
        case .barbie: return Color(red: 0x16/255, green: 0x32/255, blue: 0x73/255) // #163273
        case .hermes: return Color(red: 0/255, green: 0/255, blue: 38/255) // Deep space blue
        }
    }
    
    var secondary: Color {
        switch self {
        case .classic: return Color(red: 0.87, green: 0.27, blue: 0.27) // Soft red
        case .grass: return Color(red: 0x6F/255, green: 0xBA/255, blue: 0x2C/255) // #6FBA2C
        case .barbie: return Color(red: 0xFA/255, green: 0x51/255, blue: 0x7C/255) // #FA517C
        case .hermes: return Color(red: 255/255, green: 119/255, blue: 15/255) // Cosmic orange
        }
    }
    
    var textAndIcon: Color {
        return .white.opacity(0.9) // Semi-transparent white for good contrast
    }
    
    var disabledBackground: Color {
        return .gray // Common gray for disabled state across all schemes
    }
} 