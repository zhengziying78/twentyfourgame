import SwiftUI

// MARK: - Responsive Button View

public struct ResponsiveActionButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    let isEnabled: Bool
    let backgroundColor: Color
    let foregroundColor: Color
    let trigger: Bool
    
    public init(
        icon: String,
        text: String,
        action: @escaping () -> Void,
        isEnabled: Bool = true,
        backgroundColor: Color,
        foregroundColor: Color,
        trigger: Bool = false
    ) {
        self.icon = icon
        self.text = text
        self.action = action
        self.isEnabled = isEnabled
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.trigger = trigger
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: ResponsiveLayout.actionButtonSpacing) {
                Image(systemName: icon)
                    .font(.system(size: DeviceScale.Font.actionButtonIcon, weight: .medium))
                    .scaleEffect(trigger ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: trigger)
                Text(text)
                    .font(.system(size: DeviceScale.Font.actionButtonText, weight: .medium))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
        }
        .disabled(!isEnabled)
    }
}