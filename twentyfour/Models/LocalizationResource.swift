import Foundation

struct LocalizationResource {
    static func string(for key: LocalizedKey, language: Language) -> String {
        switch language.effectiveLanguage {
        case .chinese:
            return key.chinese
        default:
            return key.english
        }
    }
}

enum LocalizedKey {
    case playButton
    case solveButton
    case backButton
    case settingsTitle
    case settingsGeneral
    case settingsLanguage
    case settingsColorScheme
    case selectDifficulties
    case difficultyLabel
    case difficultyEasy
    case difficultyMedium
    case difficultyHard
    case difficultyHardest
    case handNumberPrefix
    case helpTitle
    case historyTitle
    case historyEmpty
    case historyLimitNote
    case colorSchemeClassic
    case colorSchemeGrass
    case colorSchemeNavy
    case colorSchemeSteel
    case colorSchemeRouge
    case colorSchemeBarbie
    case colorSchemeHermes
    case settingsAppIcon
    case settingsAppIconAutoChange
    case settingsAppIconAutoChangeDescription
    
    var english: String {
        switch self {
        case .playButton: return "Play"
        case .solveButton: return "Solve"
        case .backButton: return "Back"
        case .settingsTitle: return "Settings"
        case .settingsGeneral: return "General"
        case .settingsLanguage: return "Language"
        case .settingsColorScheme: return "Color Scheme"
        case .selectDifficulties: return "Select Difficulties"
        case .difficultyLabel: return "Difficulty: "
        case .difficultyEasy: return "Easy"
        case .difficultyMedium: return "Medium"
        case .difficultyHard: return "Hard"
        case .difficultyHardest: return "Hardest"
        case .handNumberPrefix: return "No. "
        case .helpTitle: return "How to Play"
        case .historyTitle: return "History"
        case .historyEmpty: return "No history yet"
        case .historyLimitNote: return "Showing the most recent 20 hands"
        case .colorSchemeClassic: return "Classic"
        case .colorSchemeGrass: return "Grass"
        case .colorSchemeNavy: return "Navy"
        case .colorSchemeSteel: return "Steel"
        case .colorSchemeRouge: return "Rouge"
        case .colorSchemeBarbie: return "Barbie"
        case .colorSchemeHermes: return "Hermes"
        case .settingsAppIcon: return "App Icon"
        case .settingsAppIconAutoChange: return "Auto-change with color scheme"
        case .settingsAppIconAutoChangeDescription: return "When enabled, the app icon will automatically change to match your selected color scheme."
        }
    }
    
    var chinese: String {
        switch self {
        case .playButton: return "换一组"
        case .solveButton: return "看答案"
        case .backButton: return "返回"
        case .settingsTitle: return "设置"
        case .settingsGeneral: return "通用"
        case .settingsLanguage: return "语言"
        case .settingsColorScheme: return "配色方案"
        case .selectDifficulties: return "选择难度"
        case .difficultyLabel: return "难度："
        case .difficultyEasy: return "简单"
        case .difficultyMedium: return "中等"
        case .difficultyHard: return "有点难"
        case .difficultyHardest: return "很难"
        case .handNumberPrefix: return "编号 "
        case .helpTitle: return "玩法说明"
        case .historyTitle: return "历史记录"
        case .historyEmpty: return "暂无记录"
        case .historyLimitNote: return "显示最近20组"
        case .colorSchemeClassic: return "经典"
        case .colorSchemeGrass: return "草绿"
        case .colorSchemeNavy: return "藏青"
        case .colorSchemeSteel: return "缙云"
        case .colorSchemeRouge: return "胭脂"
        case .colorSchemeBarbie: return "芭比"
        case .colorSchemeHermes: return "爱马仕"
        case .settingsAppIcon: return "应用图标"
        case .settingsAppIconAutoChange: return "跟随配色方案自动更改"
        case .settingsAppIconAutoChangeDescription: return "是否根据配色方案自动更改应用图标。"
        }
    }
} 