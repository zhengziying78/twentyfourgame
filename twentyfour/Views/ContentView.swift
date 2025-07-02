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
            .font(.custom("Menlo-Bold", size: max(finalSize, UIDevice.current.userInterfaceIdiom == .pad ? 24 : 20))) // Ensure minimum readable size
    }
}

struct SolutionOverlay: View {
    let solution: String
    let onDismiss: () -> Void
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
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
                            .foregroundColor(.black.opacity(0.8))
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
                                        .fill(colorSchemeManager.currentScheme.primary.opacity(0.6))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "xmark")
                                        .foregroundColor(colorSchemeManager.currentScheme.textAndIcon)
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 18 : 16, weight: .bold))
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
    @StateObject private var languageSettings = LanguagePreferences.shared
    @StateObject private var historyManager = HistoryManager.shared
    @StateObject private var colorSchemeManager = ColorSchemeManager.shared
    @State private var showingSolution = false
    @State private var showingFilter = false
    @State private var showingSettings = false
    @State private var showingHelp = false
    @State private var showingHistory = false
    @State private var isCardsFaceUp = false
    @State private var isFlipping = false
    @State private var exportPath: String = ""
    @State private var showingExportAlert = false
    @State private var playButtonTrigger = false
    @State private var solveButtonTrigger = false
    @State private var showingColorPicker = false
    @State private var randomizedCards: [Card] = []
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color for the entire view
                colorSchemeManager.currentScheme.primary
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top part - Navigation bar with primary background
                    HStack(spacing: ContentViewConstants.Layout.navigationIconSpacing) {
                        Spacer()
                        Button(action: {
                            showingFilter = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: ContentViewConstants.Font.navigationIcon))
                                .foregroundColor(colorSchemeManager.currentScheme.textAndIcon)
                        }
                        .disabled(showingSolution)
                        
                        Button(action: {
                            showingHistory = true
                        }) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: ContentViewConstants.Font.navigationIcon))
                                .foregroundColor(colorSchemeManager.currentScheme.textAndIcon)
                        }
                        .disabled(showingSolution)
                        
                        Button(action: {
                            showingHelp = true
                        }) {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: ContentViewConstants.Font.navigationIcon))
                                .foregroundColor(colorSchemeManager.currentScheme.textAndIcon)
                        }
                        .disabled(showingSolution)
                        
                        Button(action: {
                            showingColorPicker = true
                        }) {
                            Image(systemName: "paintpalette")
                                .font(.system(size: ContentViewConstants.Font.navigationIcon))
                                .foregroundColor(colorSchemeManager.currentScheme.textAndIcon)
                        }
                        .disabled(showingSolution)
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "globe")
                                .font(.system(size: ContentViewConstants.Font.navigationIcon))
                                .foregroundColor(colorSchemeManager.currentScheme.textAndIcon)
                        }
                        .disabled(showingSolution)
                    }
                    .padding(.horizontal, ContentViewConstants.Layout.navigationPaddingHorizontal)
                    .padding(.vertical, ContentViewConstants.Layout.navigationPaddingVertical)
                    .frame(height: SharedUIConstants.topBarHeight)
                    
                    // Middle part - Cards and difficulty indicator
                    VStack(spacing: SharedUIConstants.Layout.buttonSpacing) {
                        // Fixed spacing at top
                        Spacer()
                            .frame(height: ContentViewConstants.Layout.cardSectionTopSpacing)
                        
                        LazyVGrid(columns: columns, spacing: ContentViewConstants.Layout.cardGridSpacing) {
                            ForEach(0..<4) { index in
                                CardView(
                                    card: randomizedCards[safe: index],
                                    isFaceUp: isCardsFaceUp
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: UIScreen.main.bounds.width * SharedUIConstants.Card.aspectRatio)
                            }
                        }
                        .padding(.horizontal, ContentViewConstants.Layout.cardGridPaddingHorizontal)
                        
                        // Fixed-height container for difficulty indicator
                        VStack {
                            if let currentHand = gameManager.currentHand {
                                DifficultyIndicator(
                                    difficulty: currentHand.difficulty
                                )
                                .opacity(isCardsFaceUp ? 1 : 0)
                                .animation(.easeInOut(duration: ContentViewConstants.Animation.cardFlipDuration), value: isCardsFaceUp)
                            }
                        }
                        .frame(height: ContentViewConstants.Layout.difficultyIndicatorHeight)
                        
                        // Fixed spacing at bottom
                        Spacer()
                            .frame(height: ContentViewConstants.Layout.cardSectionBottomSpacing)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color.white)
                    
                    // Bottom part - Action buttons
                    HStack(spacing: ContentViewConstants.Layout.actionButtonSeparator) {
                        // Play button
                        Button(action: {
                            playButtonTrigger.toggle()
                            
                            if gameManager.currentHand != nil {
                                isFlipping = true
                                withAnimation(.easeInOut(duration: ContentViewConstants.Animation.cardFlipDuration)) {
                                    isCardsFaceUp = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + ContentViewConstants.Animation.cardFlipDelay) {
                                    gameManager.getRandomHand()
                                    if let hand = gameManager.currentHand, let handNumber = gameManager.handNumber {
                                        randomizedCards = hand.cards.shuffled()
                                        historyManager.addEntry(
                                            handNumber: handNumber,
                                            cards: randomizedCards,
                                            difficulty: hand.difficulty,
                                            solution: gameManager.formattedSolution
                                        )
                                    }
                                    withAnimation(.easeInOut(duration: ContentViewConstants.Animation.cardFlipDuration)) {
                                        isCardsFaceUp = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + ContentViewConstants.Animation.cardFlipDelay) {
                                        isFlipping = false
                                    }
                                }
                            } else {
                                isFlipping = true
                                gameManager.getRandomHand()
                                if let hand = gameManager.currentHand, let handNumber = gameManager.handNumber {
                                    randomizedCards = hand.cards.shuffled()
                                    historyManager.addEntry(
                                        handNumber: handNumber,
                                        cards: randomizedCards,
                                        difficulty: hand.difficulty,
                                        solution: gameManager.formattedSolution
                                    )
                                }
                                withAnimation(.easeInOut(duration: ContentViewConstants.Animation.cardFlipDuration)) {
                                    isCardsFaceUp = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + ContentViewConstants.Animation.cardFlipDelay) {
                                    isFlipping = false
                                }
                            }
                        }) {
                            HStack(spacing: ContentViewConstants.Layout.actionButtonIconTextSpacing) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: ContentViewConstants.Font.actionButtonIcon, weight: .medium))
                                    .scaleEffect(playButtonTrigger ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: playButtonTrigger)
                                Text(LocalizationResource.string(for: .playButton, language: languageSettings.language))
                                    .font(.system(size: ContentViewConstants.Font.actionButtonText, weight: .medium))
                            }
                            .foregroundColor(colorSchemeManager.currentScheme.textAndIcon)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(colorSchemeManager.currentScheme.primary)
                        }
                        .disabled(isFlipping)
                        
                        // Solve button
                        Button(action: {
                            solveButtonTrigger.toggle()
                            showingSolution = true
                        }) {
                            HStack(spacing: ContentViewConstants.Layout.actionButtonIconTextSpacing) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: ContentViewConstants.Font.actionButtonIcon, weight: .medium))
                                    .scaleEffect(solveButtonTrigger ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: solveButtonTrigger)
                                Text(LocalizationResource.string(for: .solveButton, language: languageSettings.language))
                                    .font(.system(size: ContentViewConstants.Font.actionButtonText, weight: .medium))
                            }
                            .foregroundColor(colorSchemeManager.currentScheme.textAndIcon)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(gameManager.currentHand != nil && !isFlipping ? 
                                colorSchemeManager.currentScheme.secondary :
                                colorSchemeManager.currentScheme.disabledBackground)
                        }
                        .disabled(gameManager.currentHand == nil || isFlipping)
                    }
                    .frame(height: ContentViewConstants.Layout.actionButtonHeight)
                }
                .ignoresSafeArea(edges: .bottom)
                
                // Solution overlay
                if showingSolution {
                    SolutionOverlay(
                        solution: gameManager.formattedSolution,
                        onDismiss: { 
                            showingSolution = false
                        }
                    )
                    .transition(.opacity)
                }
                
                // Filter overlay
                if showingFilter {
                    PopupContainer(
                        content: { DifficultyFilter(onDismiss: { showingFilter = false }) },
                        onDismiss: { showingFilter = false }
                    )
                }
                
                // Help overlay
                if showingHelp {
                    PopupContainer(
                        content: { HelpOverlay(onDismiss: { showingHelp = false }) },
                        onDismiss: { showingHelp = false }
                    )
                }
                
                // History overlay
                if showingHistory {
                    PopupContainer(
                        content: { HistoryView(onDismiss: { showingHistory = false }) },
                        onDismiss: { showingHistory = false }
                    )
                }
                
                // Color scheme picker overlay
                if showingColorPicker {
                    PopupContainer(
                        content: { ColorSchemePicker(onDismiss: { 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                showingColorPicker = false
                            }
                        }) },
                        onDismiss: { 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                showingColorPicker = false
                            }
                        }
                    )
                }
                
                // Settings overlay
                if showingSettings {
                    PopupContainer(
                        content: { LanguagePicker(onDismiss: { 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                showingSettings = false
                            }
                        }) },
                        onDismiss: { 
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                showingSettings = false
                            }
                        }
                    )
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                isCardsFaceUp = false
            }
            .alert("Icon Exported", isPresented: $showingExportAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("All app icons have been exported to:\n\(exportPath)")
            }
        }
        .navigationViewStyle(.stack)
        .onChange(of: showingColorPicker) { newValue in
            if newValue {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showingColorPicker = true
                }
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