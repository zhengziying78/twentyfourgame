import SwiftUI

struct HelpOverlay: View {
    let onDismiss: () -> Void
    @ObservedObject private var settings = SettingsPreferences.shared
    
    private var helpContent: AttributedString {
        let markdown = settings.language == .chinese ? chineseHelpMarkdown : englishHelpMarkdown
        return (try? AttributedString(markdown: markdown, options: AttributedString.MarkdownParsingOptions(
            interpretedSyntax: .inlineOnlyPreservingWhitespace
        ))) ?? AttributedString()
    }
    
    private var englishHelpMarkdown: String {
        """
        # 24 is an arithmetic puzzle where:

        • You are dealt 4 cards
        • Use these 4 numbers exactly once each
        • Through addition, subtraction, multiplication, division, and parentheses, make the result equal 24

        ## Card Values:
        • A represents 1
        • J, Q, K represent 11, 12, 13 respectively

        ## Allowed Operations:
        • Addition (+)
        • Subtraction (-)
        • Multiplication (×)
        • Division (÷)
        • Parentheses ( )

        ## Not Allowed:
        • Square root
        • Logarithms
        • Powers/exponents
        • Factorials
        • Other advanced operations

        ## Examples:
        • 7, 2, 4, 1 → (7-2) × 4 × 1 = 24
        • 4, 7, 8, 8 → (7-(8÷8)) × 4 = 24
        • 3, 3, 8, 8 → (8÷8 + 3) × 8 = 24

        Difficulty levels range from Easy to Hardest, indicated by the number of stars.

        ## Tips:
        • Each number must be used exactly once
        • Parentheses can be used to change operation order
        • Decimal numbers are allowed in intermediate steps, but the final result must be 24

        ## Important Note:
        In this game, we ensure that every hand dealt has at least one solution. While some combinations of four numbers cannot make 24, these combinations will not appear in the game.

        [Learn more: Wikipedia](https://en.wikipedia.org/wiki/24_(puzzle))
        """
    }
    
    private var chineseHelpMarkdown: String {
        """
        # 24点是一个数字游戏，规则如下：

        • 每次发4张牌
        • 使用这4个数字，恰好每个数字使用一次
        • 通过加减乘除和括号，使最终结果等于24

        ## 牌面数值：
        • A 代表 1
        • J、Q、K 分别代表 11、12、13

        ## 允许的运算：
        • 加法 (+)
        • 减法 (-)
        • 乘法 (×)
        • 除法 (÷)
        • 括号 ( )

        ## 不允许的运算：
        • 平方根
        • 对数
        • 幂运算
        • 阶乘
        • 其他高级运算

        ## 例如：
        • 7, 2, 4, 1 → (7-2) × 4 × 1 = 24
        • 4, 7, 8, 8 → (7-(8÷8)) × 4 = 24
        • 3, 3, 8, 8 → (8÷8 + 3) × 8 = 24

        难度等级从简单到很难分为四个级别，由星星数量表示。

        ## 提示：
        • 每个数字必须使用一次，且只能使用一次
        • 可以使用括号来改变运算顺序
        • 中间步骤允许出现小数，但最终结果必须是24

        ## 特别说明：
        在这个游戏中，我们确保每一手牌都至少有一个解。虽然有些数字组合无法得到24，但这些组合不会出现在游戏中。
        """
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
                Text(helpContent)
                    .textSelection(.enabled)  // Allow text selection for copying
                    .padding(.horizontal, HelpOverlayConstants.Layout.contentPaddingHorizontal)
                    .padding(.vertical, HelpOverlayConstants.Layout.contentPaddingTop)
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