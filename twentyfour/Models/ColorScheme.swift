import SwiftUI

enum ColorScheme: String, CaseIterable, Identifiable {
    case classic
    case grass
    case navy
    case steel
    case rouge
    case barbie
    case hermes
    
    var id: String { rawValue }
    
    var localizedKey: LocalizedKey {
        switch self {
        case .classic: return .colorSchemeClassic
        case .grass: return .colorSchemeGrass
        case .navy: return .colorSchemeNavy
        case .steel: return .colorSchemeSteel
        case .rouge: return .colorSchemeRouge
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
        case .navy: return Color(red: 4/255, green: 35/255, blue: 65/255) // Navy blue
        case .steel: return Color(red: 6/255, green: 134/255, blue: 173/255) // Steel blue
        case .rouge: return Color(red: 0x2E/255, green: 0x4D/255, blue: 0x7C/255) // #2E4D7C
        case .barbie: return Color(red: 0x16/255, green: 0x32/255, blue: 0x73/255) // #163273
        case .hermes: return Color(red: 0/255, green: 0/255, blue: 38/255) // Deep space blue
        }
    }
    
    var secondary: Color {
        switch self {
        case .classic: return Color(red: 0.87, green: 0.27, blue: 0.27) // Soft red
        case .grass: return Color(red: 0x6F/255, green: 0xBA/255, blue: 0x2C/255) // #6FBA2C
        case .navy: return Color(red: 186/255, green: 91/255, blue: 184/255) // Purple
        case .steel: return Color(red: 214/255, green: 76/255, blue: 47/255) // Coral red
        case .rouge: return Color(red: 0xAD/255, green: 0x1B/255, blue: 0x26/255) // #AD1B26
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