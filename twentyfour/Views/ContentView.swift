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
                .frame(height: 240)
                
                Spacer()
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var gameManager = GameManager.shared
    @State private var showingSolution = false
    @State private var showingFilter = false
    @State private var isCardsFaceUp = false
    @State private var isFlipping = false
    @State private var exportPath: String = ""
    @State private var showingExportAlert = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 16) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(0..<4) { index in
                            CardView(
                                card: gameManager.currentHand?.cards[safe: index],
                                isFaceUp: isCardsFaceUp
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.width * 0.56)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    
                    // Always show a container for the difficulty indicator
                    if let currentHand = gameManager.currentHand,
                       let handNumber = gameManager.currentHandNumber {
                        DifficultyIndicator(
                            difficulty: currentHand.difficulty,
                            handNumber: handNumber
                        )
                        .opacity(isCardsFaceUp ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isCardsFaceUp)
                    } else {
                        // Invisible placeholder with the same size as DifficultyIndicator
                        VStack(spacing: 4) {  // Match DifficultyIndicator spacing
                            Text("No. 1")
                                .font(.system(size: 16, weight: .medium))
                            HStack(spacing: 8) {
                                Text("Difficulty: Easy")
                                    .font(.system(size: 16, weight: .medium))
                                HStack(spacing: 2) {
                                    ForEach(0..<4) { _ in
                                        Image(systemName: "star")
                                            .font(.system(size: 12))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)  // Match DifficultyIndicator padding
                        .opacity(0)
                    }
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            Button(action: {
                                // If we already have cards, flip them face down first
                                if gameManager.currentHand != nil {
                                    isFlipping = true
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isCardsFaceUp = false
                                    }
                                    
                                    // After cards are face down, get new hand and flip them up
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        gameManager.getRandomHand()
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
                                    gameManager.getRandomHand()
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
                                            .fill(gameManager.currentHand != nil && !isFlipping ? Color.red.opacity(0.9) : Color.gray)
                                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    )
                            }
                            .disabled(gameManager.currentHand == nil || isFlipping)
                        }
                        
                        Button(action: {
                            Task {
                                await IconExporter.exportIcon()
                                if let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                                    exportPath = docURL.path
                                    showingExportAlert = true
                                }
                            }
                        }) {
                            Text("Export App Icon")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.9))
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                        }
                        .hidden()
                    }
                    .padding(.horizontal, 32)
                }
                
                // Solution overlay
                if showingSolution {
                    SolutionOverlay(
                        solution: gameManager.formattedSolution,
                        onDismiss: { showingSolution = false }
                    )
                    .transition(.opacity)
                }
                
                // Filter overlay
                if showingFilter {
                    FilterOverlay(onDismiss: { showingFilter = false })
                        .transition(.opacity)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            showingFilter = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 20))
                        }
                        .disabled(showingSolution)
                        
                        Button(action: {
                            // Settings action will be implemented later
                        }) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20))
                        }
                        .disabled(showingSolution)
                    }
                }
            }
            .onAppear {
                // Start with cards face down
                isCardsFaceUp = false
            }
            .alert("Icon Exported", isPresented: $showingExportAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The app icon has been exported to:\n\(exportPath)")
            }
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