import SwiftUI

struct PopupContainer<Content: View>: View {
    let content: Content
    let onDismiss: () -> Void
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    init(@ViewBuilder content: @escaping () -> Content, onDismiss: @escaping () -> Void) {
        self.content = content()
        self.onDismiss = onDismiss
    }
    
    private var maxHeight: CGFloat {
        UIScreen.main.bounds.height - SharedUIConstants.topBarHeight
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Semi-transparent background that lets content show through
            Color.black.opacity(PopupContainerConstants.Opacity.backgroundOverlay)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(
                        response: PopupContainerConstants.Animation.springResponse,
                        dampingFraction: PopupContainerConstants.Animation.springDamping
                    )) {
                        onDismiss()
                    }
                }
            
            // Content container
            VStack(spacing: 0) {
                content
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { } // Prevent taps from reaching the background only in content area
                    .background(Color(UIColor.systemBackground).opacity(PopupContainerConstants.Opacity.contentBackground))
            }
            .frame(maxWidth: .infinity)
            .offset(y: SharedUIConstants.topBarHeight)
        }
        .transition(.asymmetric(
            insertion: .offset(y: -UIScreen.main.bounds.height),
            removal: .offset(y: -UIScreen.main.bounds.height)
        ))
    }
} 