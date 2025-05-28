import SwiftUI

struct HelpOverlay: View {
    let onDismiss: () -> Void
    @ObservedObject private var settings = SettingsPreferences.shared
    
    private var helpContent: String {
        if settings.language == .chinese {
            return """
            24点是一个数字游戏，规则如下：

            • 每次发4张牌
            • 使用这4个数字，恰好每个数字使用一次
            • 通过加减乘除和括号，使最终结果等于24

            牌面数值：
            • A 代表 1
            • J、Q、K 分别代表 11、12、13

            允许的运算：
            • 加法 (+)
            • 减法 (-)
            • 乘法 (×)
            • 除法 (÷)
            • 括号 ( )

            不允许的运算：
            • 平方根
            • 对数
            • 幂运算
            • 阶乘
            • 其他高级运算

            例如：
            • 7, 2, 4, 1 → (7-2) × 4 × 1 = 24
            • 4, 7, 8, 8 → (7-(8÷8)) × 4 = 24
            • 3, 3, 8, 8 → (8÷8 + 3) × 8 = 24

            难度等级从简单到很难分为四个级别，由星星数量表示。

            提示：
            • 每个数字必须使用一次，且只能使用一次
            • 可以使用括号来改变运算顺序
            • 中间步骤允许出现小数，但最终结果必须是24

            特别说明：
            在这个游戏中，我们确保每一手牌都至少有一个解。虽然有些数字组合无法得到24，但这些组合不会出现在游戏中。
            """
        } else {
            return """
            24 is an arithmetic puzzle where:

            • You are dealt 4 cards
            • Use these 4 numbers exactly once each
            • Through addition, subtraction, multiplication, division, and parentheses, make the result equal 24

            Card Values:
            • A represents 1
            • J, Q, K represent 11, 12, 13 respectively

            Allowed Operations:
            • Addition (+)
            • Subtraction (-)
            • Multiplication (×)
            • Division (÷)
            • Parentheses ( )

            Not Allowed:
            • Square root
            • Logarithms
            • Powers/exponents
            • Factorials
            • Other advanced operations

            Examples:
            • 7, 2, 4, 1 → (7-2) × 4 × 1 = 24
            • 4, 7, 8, 8 → (7-(8÷8)) × 4 = 24
            • 3, 3, 8, 8 → (8÷8 + 3) × 8 = 24

            Difficulty levels range from Easy to Hardest, indicated by the number of stars.

            Tips:
            • Each number must be used exactly once
            • Parentheses can be used to change operation order
            • Decimal numbers are allowed in intermediate steps, but the final result must be 24

            Important Note:
            In this game, we ensure that every hand dealt has at least one solution. While some combinations of four numbers cannot make 24, these combinations will not appear in the game.
            """
        }
    }
    
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
                
                // Help content container
                ZStack {
                    // White background
                    Color.white.opacity(0.95)
                    
                    VStack(spacing: 20) {
                        Text(LocalizationResource.string(for: .helpTitle, language: settings.language))
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.top, 24)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(helpContent)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black.opacity(0.8))
                                    .lineSpacing(4)
                                
                                if settings.language == .english {
                                    Link("Learn more: Wikipedia", destination: URL(string: "https://en.wikipedia.org/wiki/24_(puzzle)")!)
                                        .font(.system(size: 16))
                                        .padding(.top, 8)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                        }
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
                .frame(height: 480)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    HelpOverlay(onDismiss: {})
} 