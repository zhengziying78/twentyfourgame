import Foundation

class FilterPreferences: ObservableObject {
    static let shared = FilterPreferences()
    
    @Published private(set) var selectedDifficulties: Set<Difficulty>
    
    private let defaults = UserDefaults.standard
    private let key = "selectedDifficulties"
    
    private init() {
        // Initialize with a default value first
        self.selectedDifficulties = Set(Difficulty.allCases)
        
        // Then load saved preferences if they exist
        loadFromDisk()
    }
    
    private func loadFromDisk() {
        if let saved = defaults.array(forKey: key) as? [String] {
            let loaded = Set(saved.compactMap { difficultyFromString($0) })
            // Ensure we always have at least one difficulty selected
            if !loaded.isEmpty {
                selectedDifficulties = loaded
            }
        }
    }
    
    func toggleDifficulty(_ difficulty: Difficulty) {
        var newSelection = selectedDifficulties
        
        if newSelection.contains(difficulty) {
            // Don't allow deselecting if it's the last selected difficulty
            if newSelection.count > 1 {
                newSelection.remove(difficulty)
            }
        } else {
            newSelection.insert(difficulty)
        }
        
        selectedDifficulties = newSelection
        saveToDisk()
    }
    
    private func saveToDisk() {
        let difficultyStrings = selectedDifficulties.map { difficultyToString($0) }
        defaults.set(difficultyStrings, forKey: key)
    }
    
    private func difficultyToString(_ difficulty: Difficulty) -> String {
        switch difficulty {
        case .easy: return "easy"
        case .medium: return "medium"
        case .hard: return "hard"
        case .hardest: return "hardest"
        }
    }
    
    private func difficultyFromString(_ string: String) -> Difficulty? {
        switch string {
        case "easy": return .easy
        case "medium": return .medium
        case "hard": return .hard
        case "hardest": return .hardest
        default: return nil
        }
    }
} 