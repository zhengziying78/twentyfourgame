import SwiftUI

enum ColorScheme: String, CaseIterable, Identifiable {
    case classic
    case hermes
    case barbie
    case seahawks
    case barcelona
    case interMilan
    case psg
    case lakers
    
    var id: String { rawValue }
    
    var localizationKey: LocalizedKey {
        switch self {
        case .classic: return .colorSchemeClassic
        case .hermes: return .colorSchemeHermes
        case .barbie: return .colorSchemeBarbie
        case .seahawks: return .colorSchemeSeahawks
        case .barcelona: return .colorSchemeBarcelona
        case .interMilan: return .colorSchemeInterMilan
        case .psg: return .colorSchemePSG
        case .lakers: return .colorSchemeLakers
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
        case .seahawks: return Color(red: 0/255, green: 34/255, blue: 68/255) // RGB(0, 34, 68)
        case .barcelona: return Color(red: 0xA5/255, green: 0x00/255, blue: 0x44/255) // #A50044
        case .interMilan: return Color(red: 4/255, green: 7/255, blue: 7/255) // RGB(4, 7, 7)
        case .psg: return Color(red: 0x00/255, green: 0x41/255, blue: 0x70/255) // #004170
        case .lakers: return Color(red: 85/255, green: 37/255, blue: 130/255) // RGB(85, 37, 130)
        }
    }
    
    var secondary: Color {
        switch self {
        case .classic: return Color(red: 0.87, green: 0.27, blue: 0.27) // Soft red
        case .hermes: return Color(red: 0xFF/255, green: 0x87/255, blue: 0x00/255) // #FF8700
        case .barbie: return Color(red: 0xFA/255, green: 0x51/255, blue: 0x7C/255) // #FA517C
        case .seahawks: return Color(red: 105/255, green: 190/255, blue: 40/255) // RGB(105, 190, 40)
        case .barcelona: return Color(red: 0x00/255, green: 0x4D/255, blue: 0x98/255) // #004D98
        case .interMilan: return Color(red: 18/255, green: 102/255, blue: 171/255) // RGB(18, 102, 171)
        case .psg: return Color(red: 0xDA/255, green: 0x29/255, blue: 0x1C/255) // #DA291C
        case .lakers: return Color(red: 253/255, green: 185/255, blue: 39/255) // RGB(253, 185, 39)
        }
    }
    
    var textAndIcon: Color {
        return .white.opacity(0.9) // Semi-transparent white for good contrast
    }
    
    var disabledBackground: Color {
        return .gray // Common gray for disabled state across all schemes
    }
} 