import SwiftUI

struct ContentView: View {
    @StateObject private var gameData = GameData.shared
    @State private var showingSolution = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Twenty Four")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<4) { index in
                    CardView(
                        card: gameData.currentHand?.cards[safe: index],
                        isFaceUp: gameData.currentHand != nil
                    )
                }
            }
            .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    gameData.getRandomHand()
                }) {
                    Text("Play")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    showingSolution = true
                }) {
                    Text("Solve")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(gameData.currentHand != nil ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(gameData.currentHand == nil)
            }
            .padding(.horizontal)
        }
        .alert("Solution", isPresented: $showingSolution) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(gameData.currentHand?.solution ?? "")
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