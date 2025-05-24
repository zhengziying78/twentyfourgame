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
    case difficultyLabel
    case difficultyEasy
    case difficultyMedium
    case difficultyHard
    case difficultyHardest
    case settingsTitle
    case settingsGeneral
    case settingsLanguage
    case backButton
    case selectDifficulties
    
    var english: String {
        switch self {
        case .playButton: return "Play"
        case .solveButton: return "Solve"
        case .difficultyLabel: return "Difficulty: "
        case .difficultyEasy: return "Easy"
        case .difficultyMedium: return "Medium"
        case .difficultyHard: return "Hard"
        case .difficultyHardest: return "Hardest"
        case .settingsTitle: return "Settings"
        case .settingsGeneral: return "General"
        case .settingsLanguage: return "Language"
        case .backButton: return "Back"
        case .selectDifficulties: return "Select Difficulties"
        }
    }
    
    var chinese: String {
        switch self {
        case .playButton: return "换一组"
        case .solveButton: return "看答案"
        case .difficultyLabel: return "难度: "
        case .difficultyEasy: return "简单"
        case .difficultyMedium: return "中等"
        case .difficultyHard: return "有点难"
        case .difficultyHardest: return "非常难"
        case .settingsTitle: return "设置"
        case .settingsGeneral: return "通用"
        case .settingsLanguage: return "语言"
        case .backButton: return "返回"
        case .selectDifficulties: return "选择难度"
        }
    }
} 