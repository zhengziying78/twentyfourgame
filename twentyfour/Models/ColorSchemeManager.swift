import SwiftUI

class ColorSchemeManager: ObservableObject {
    static let shared = ColorSchemeManager()
    
    @Published private(set) var currentScheme: ColorScheme {
        didSet {
            saveToUserDefaults()
        }
    }
    
    private let defaults = UserDefaults.standard
    private let key = "selectedColorScheme"
    
    private init() {
        // Load saved scheme or use classic as default
        if let savedScheme = defaults.string(forKey: key),
           let scheme = ColorScheme(rawValue: savedScheme) {
            self.currentScheme = scheme
        } else {
            self.currentScheme = .classic
        }
    }
    
    func setScheme(_ scheme: ColorScheme) {
        currentScheme = scheme
    }
    
    private func saveToUserDefaults() {
        defaults.set(currentScheme.rawValue, forKey: key)
    }
} 