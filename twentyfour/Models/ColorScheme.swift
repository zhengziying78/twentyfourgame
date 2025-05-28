import SwiftUI

enum ColorScheme: String, CaseIterable, Identifiable {
    case classic
    case hermes
    case barbie
    
    var id: String { rawValue }
    
    var localizationKey: LocalizedKey {
        switch self {
        case .classic: return .colorSchemeClassic
        case .hermes: return .colorSchemeHermes
        case .barbie: return .colorSchemeBarbie
        }
    }
    
    func localizedName(language: Language) -> String {
        return LocalizationResource.string(for: localizationKey, language: language)
    }
    
    var primary: Color {
        switch self {
        case .classic: return Color(white: 0.15) // Soft black
        case .hermes: return Color(red: 0x1A/255, green: 0x1A/255, blue: 0x1A/255) // #1A1A1A
        case .barbie: return Color(red: 0x16/255, green: 0x32/255, blue: 0x73/255) // #163273
        }
    }
    
    var secondary: Color {
        switch self {
        case .classic: return Color(red: 0.87, green: 0.27, blue: 0.27) // Soft red
        case .hermes: return Color(red: 0xFF/255, green: 0x87/255, blue: 0x00/255) // #FF8700
        case .barbie: return Color(red: 0xFA/255, green: 0x51/255, blue: 0x7C/255) // #FA517C
        }
    }
    
    var textAndIcon: Color {
        return .white.opacity(0.9) // Semi-transparent white for good contrast
    }
    
    var disabledBackground: Color {
        return .gray // Common gray for disabled state across all schemes
    }
} 