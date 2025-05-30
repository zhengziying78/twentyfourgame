import SwiftUI
import MarkdownUI

struct HelpOverlay: View {
    let onDismiss: () -> Void
    @ObservedObject private var settings = SettingsPreferences.shared
    
    private var helpContent: String {
        let filename = settings.language == .chinese ? "help.zh" : "help.en"
        guard let path = Bundle.main.path(forResource: filename, ofType: "md"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return "Help content not found"
        }
        return content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with dismiss button
            HStack {
                Spacer()
                
                Text(LocalizationResource.string(for: .helpTitle, language: settings.language))
                    .font(.system(size: HelpOverlayConstants.Font.titleSize, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: HelpOverlayConstants.Font.dismissButtonSize))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, HelpOverlayConstants.Layout.headerPaddingHorizontal)
            .padding(.vertical, HelpOverlayConstants.Layout.headerPaddingVertical)
            
            Divider()
                .background(Color(UIColor.separator))
            
            ScrollView {
                Markdown(helpContent)
                    .textSelection(.enabled)
                    .padding(.horizontal, HelpOverlayConstants.Layout.contentPaddingHorizontal)
                    .padding(.vertical, HelpOverlayConstants.Layout.contentPaddingTop)
                    .markdownTheme(.gitHub)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: HelpOverlayConstants.Layout.bottomSafeAreaInset)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
}

#Preview {
    HelpOverlay(onDismiss: {})
} 