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
    @StateObject private var settings = SettingsPreferences.shared
    @State private var showingSolution = false
    @State private var showingFilter = false
    @State private var showingSettings = false
    @State private var showingHelp = false
    @State private var isCardsFaceUp = false
    @State private var isFlipping = false
    @State private var exportPath: String = ""
    @State private var showingExportAlert = false
    @State private var playButtonTrigger = false
    @State private var solveButtonTrigger = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color for the entire view
                Color(red: 0.2, green: 0.2, blue: 0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top part - Navigation bar with soft black background
                    HStack(spacing: 20) {
                        Spacer()
                        Button(action: {
                            showingHelp = true
                        }) {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 22))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .disabled(showingSolution)
                        
                        Button(action: {
                            showingFilter = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 22))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .disabled(showingSolution)
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 22))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .disabled(showingSolution)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .frame(height: 92)
                    
                    // Middle part - Cards and difficulty indicator
                    VStack(spacing: 24) {
                        // Add spacing to move content down
                        Spacer()
                            .frame(height: 20)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(0..<4) { index in
                                CardView(
                                    card: gameManager.currentHand?.cards[safe: index],
                                    isFaceUp: isCardsFaceUp
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: UIScreen.main.bounds.width * 0.52)
                            }
                        }
                        .padding(.horizontal, 28)
                        
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
                            VStack(spacing: 4) {
                                Text(LocalizationResource.string(for: .handNumberPrefix, language: settings.language) + "1")
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
                            .padding(.vertical, 6)
                            .opacity(0)
                        }
                        
                        Spacer(minLength: 0)
                            .layoutPriority(-1) // Lower priority means this Spacer will be compressed first
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.white)
                    
                    // Bottom part - Action buttons
                    HStack(spacing: 1) { // 1px separator line
                        // Play button
                        Button(action: {
                            playButtonTrigger.toggle()
                            
                            if gameManager.currentHand != nil {
                                isFlipping = true
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isCardsFaceUp = false
                                }
                                
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
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 24, weight: .medium))
                                    .symbolEffect(.bounce.up, options: .nonRepeating, value: playButtonTrigger)
                                Text(LocalizationResource.string(for: .playButton, language: settings.language))
                                    .font(.system(size: 20, weight: .medium))
                            }
                            .foregroundColor(.white.opacity(0.9))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                        }
                        .disabled(isFlipping)
                        
                        // Solve button
                        Button(action: {
                            solveButtonTrigger.toggle()
                            showingSolution = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 24, weight: .medium))
                                    .symbolEffect(.pulse, options: .nonRepeating, value: solveButtonTrigger)
                                Text(LocalizationResource.string(for: .solveButton, language: settings.language))
                                    .font(.system(size: 20, weight: .medium))
                            }
                            .foregroundColor(.white.opacity(0.9))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(gameManager.currentHand != nil && !isFlipping ? 
                                Color(red: 0.87, green: 0.27, blue: 0.27) :
                                Color.gray)
                        }
                        .disabled(gameManager.currentHand == nil || isFlipping)
                    }
                    .frame(height: 160) // Increased height to 160 for bottom section
                }
                .ignoresSafeArea(edges: .bottom)
                
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
                
                // Help overlay
                if showingHelp {
                    HelpOverlay(onDismiss: { showingHelp = false })
                        .transition(.opacity)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .onAppear {
                isCardsFaceUp = false
            }
            .alert("Icon Exported", isPresented: $showingExportAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The app icon has been exported to:\n\(exportPath)")
            }
        }
        .navigationViewStyle(.stack)
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