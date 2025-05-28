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
    
    var english: String {
        switch self {
        case .playButton: return "Play"
        case .solveButton: return "Solve"
        case .backButton: return "Back"
        case .settingsTitle: return "Settings"
        case .settingsGeneral: return "General"
        case .settingsLanguage: return "Language"
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
        }
    }
} 