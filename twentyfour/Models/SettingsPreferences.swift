import Foundation

enum Language: String, CaseIterable, Identifiable {
    case auto = "Auto"
    case english = "English"
    case chinese = "Chinese"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .auto: return "Auto"
        case .english: return "English"
        case .chinese: return "中文"
        }
    }
    
    var effectiveLanguage: Language {
        if self == .auto {
            // Check system language
            let preferredLanguages = Locale.preferredLanguages
            let isChineseSystem = preferredLanguages.first?.contains("zh") == true
            return isChineseSystem ? .chinese : .english
        }
        return self
    }
}

struct LocalizedStrings {
    static func playButtonText(_ language: Language) -> String {
        switch language.effectiveLanguage {
        case .chinese: return "换一组"
        default: return "Play"
        }
    }
    
    static func solveButtonText(_ language: Language) -> String {
        switch language.effectiveLanguage {
        case .chinese: return "看答案"
        default: return "Solve"
        }
    }
}

class SettingsPreferences: ObservableObject {
    static let shared = SettingsPreferences()
    
    @Published private(set) var language: Language {
        didSet {
            saveToDisk()
        }
    }
    
    private let defaults = UserDefaults.standard
    private let languageKey = "selectedLanguage"
    
    private init() {
        // Load saved language or use default
        if let savedLanguage = defaults.string(forKey: languageKey),
           let loaded = Language(rawValue: savedLanguage) {
            self.language = loaded
        } else {
            self.language = .auto
        }
    }
    
    func setLanguage(_ newLanguage: Language) {
        language = newLanguage
    }
    
    private func saveToDisk() {
        defaults.set(language.rawValue, forKey: languageKey)
    }
} 