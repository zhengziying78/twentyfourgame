import SwiftUI
#if os(macOS)
import AppKit
#endif

struct ContentView: View {
    @StateObject private var gameData = GameData.shared
    @State private var showingSolution = false
    @State private var isCardsFaceUp = false
    @State private var isFlipping = false
    @State private var exportPath: String = ""
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<4) { index in
                    CardView(
                        card: gameData.currentHand?.cards[safe: index],
                        isFaceUp: isCardsFaceUp
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.width * 0.56)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical)
            
            HStack(spacing: 20) {
                Button(action: {
                    // If we already have cards, flip them face down first
                    if gameData.currentHand != nil {
                        isFlipping = true
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isCardsFaceUp = false
                        }
                        
                        // After cards are face down, get new hand and flip them up
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            gameData.getRandomHand()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isCardsFaceUp = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isFlipping = false
                            }
                        }
                    } else {
                        // If no cards yet, just get new hand and show them
                        isFlipping = true
                        gameData.getRandomHand()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isCardsFaceUp = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isFlipping = false
                        }
                    }
                }) {
                    Text("Play")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        )
                }
                .disabled(isFlipping)
                
                Button(action: {
                    showingSolution = true
                }) {
                    Text("Solve")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(gameData.currentHand != nil && !isFlipping ? Color.red.opacity(0.9) : Color.gray)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        )
                }
                .disabled(gameData.currentHand == nil || isFlipping)
            }
            .padding(.horizontal, 32)
            
            /* Commented out: Icon Export functionality
            #if DEBUG
            // Temporary icon export button for testing
            VStack(spacing: 8) {
                Button("Export App Icon") {
                    Task {
                        let icon = IconGenerator()
                        let renderer = ImageRenderer(content: icon)
                        renderer.scale = 1.0
                        
                        // Save to Documents directory
                        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            let assetPath = documentsURL.appendingPathComponent("AppIcon.png")
                            exportPath = assetPath.path
                            print("📁 Attempting to save to: \(exportPath)")
                            
                            if let cgImage = renderer.cgImage,
                               let data = UIImage(cgImage: cgImage).pngData() {
                                do {
                                    try data.write(to: assetPath)
                                    print("✅ Successfully saved icon to Documents:")
                                    print("📍 \(exportPath)")
                                } catch {
                                    print("❌ Error saving file: \(error.localizedDescription)")
                                }
                            }
                        } else {
                            print("❌ Could not access Documents directory")
                        }
                    }
                }
                .padding(.top)
                
                if !exportPath.isEmpty {
                    Text("Icon saved to:")
                        .font(.caption)
                    Text(exportPath)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            #endif
            */
        }
        .alert("Solution", isPresented: $showingSolution) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(gameData.currentHand?.solution ?? "")
        }
        .onAppear {
            // Start with cards face down
            isCardsFaceUp = false
        }
    }
}

// Helper extension for safe array access
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    ContentView()
} 