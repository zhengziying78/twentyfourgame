import SwiftUI

struct FilterOverlay: View {
    @ObservedObject private var preferences = FilterPreferences.shared
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Filter container
                ZStack {
                    // White background
                    Color.white.opacity(0.95)
                    
                    VStack(spacing: 20) {
                        Text("Select Difficulties")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.top, 24)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                Button(action: {
                                    preferences.toggleDifficulty(difficulty)
                                }) {
                                    HStack {
                                        Image(systemName: preferences.selectedDifficulties.contains(difficulty) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(preferences.selectedDifficulties.contains(difficulty) ? .blue : .gray)
                                            .font(.system(size: 20))
                                        
                                        Text(difficultyText(difficulty))
                                            .font(.system(size: 18))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer()
                    }
                    
                    // Dismiss button overlay
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: onDismiss) {
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.6))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                
                Spacer()
            }
        }
    }
    
    private func difficultyText(_ difficulty: Difficulty) -> String {
        switch difficulty {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .hardest: return "Hardest"
        }
    }
} 