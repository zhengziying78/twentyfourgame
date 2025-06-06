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

class LanguagePreferences: ObservableObject {
    static let shared = LanguagePreferences()
    
    @Published private(set) var language: Language {
        didSet {
            saveToDisk()
        }
    }
    
    private let defaults: UserDefaults
    private let languageKey = "selectedLanguage"
    
    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        // Load saved language or use default
        if let savedLanguage = defaults.string(forKey: languageKey),
           let loaded = Language(rawValue: savedLanguage) {
            self.language = loaded
        } else {
            self.language = .auto
        }
    }
    
    #if DEBUG
    static func createForTesting(defaults: UserDefaults) -> LanguagePreferences {
        return LanguagePreferences(defaults: defaults)
    }
    
    func reset() {
        language = .auto
        defaults.removeObject(forKey: languageKey)
    }
    #endif
    
    func setLanguage(_ newLanguage: Language) {
        language = newLanguage
    }
    
    private func saveToDisk() {
        defaults.set(language.rawValue, forKey: languageKey)
        defaults.synchronize() // Ensure changes are saved immediately
    }
} 