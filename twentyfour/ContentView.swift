import SwiftUI
#if os(macOS)
import AppKit
#endif

// Custom view modifier to calculate optimal font size
struct DynamicFontSize: ViewModifier {
    let text: String
    let containerWidth: CGFloat
    
    func body(content: Content) -> some View {
        let baseSize: CGFloat = 60
        let horizontalPadding: CGFloat = 32 * 2 // Total horizontal padding
        let availableWidth = containerWidth - horizontalPadding
        let safetyMargin: CGFloat = 4 // Small safety margin to prevent any truncation
        
        // Approximate width per character (Menlo is monospace)
        let charWidth = baseSize * 0.6 // Approximate character width ratio for Menlo
        let totalWidth = charWidth * CGFloat(text.count)
        
        // Calculate scale factor to fit text in container
        let scale = (availableWidth - safetyMargin) / totalWidth
        let finalSize = baseSize * scale
        
        content
            .font(.custom("Menlo-Bold", size: max(finalSize, 20))) // Ensure minimum readable size
    }
}

struct SolutionOverlay: View {
    let solution: String
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
                
                // Solution container
                ZStack {
                    // White background
                    Color.white.opacity(0.95)
                    
                    GeometryReader { geometry in
                        // Solution text centered
                        Text(solution)
                            .modifier(DynamicFontSize(text: solution, containerWidth: geometry.size.width))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height)
                            .padding(.horizontal, 32)
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
                .frame(height: 160)
                
                Spacer()
            }
        }
    }
}

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
        ZStack {
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
            }
            
            // Solution overlay
            if showingSolution {
                SolutionOverlay(
                    solution: gameData.formattedSolution,
                    onDismiss: { showingSolution = false }
                )
                .transition(.opacity)
            }
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