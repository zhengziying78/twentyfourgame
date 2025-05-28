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
            print("DEBUG: Loading saved color scheme: \(savedScheme)")
            self.currentScheme = scheme
        } else {
            print("DEBUG: No saved scheme found, using classic as default")
            self.currentScheme = .classic
        }
        print("DEBUG: Current color scheme: \(currentScheme)")
    }
    
    func setScheme(_ scheme: ColorScheme) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScheme = scheme
        }
    }
    
    private func saveToUserDefaults() {
        defaults.set(currentScheme.rawValue, forKey: key)
        defaults.synchronize() // Ensure changes are saved immediately
    }
} 