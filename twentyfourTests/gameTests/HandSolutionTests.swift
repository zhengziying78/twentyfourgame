import XCTest
@testable import twentyfour

class HandSolutionTests: XCTestCase {
    
    // Helper function to evaluate mathematical expressions
    func evaluate(_ expression: String) -> Double? {
        // Remove spaces and parentheses for initial processing
        let expr = expression.replacingOccurrences(of: " ", with: "")
        
        // Helper function for basic operations
        func calculate(_ a: Double, _ b: Double, _ op: Character) -> Double? {
            switch op {
            case "+": return a + b
            case "-": return a - b
            case "*", "×": return a * b
            case "/", "÷": return b != 0 ? a / b : nil
            default: return nil
            }
        }
        
        // Helper function to evaluate expression with parentheses
        func evaluateWithParentheses(_ expr: String) -> Double? {
            // Find innermost parentheses
            var start = -1
            
            for (i, char) in expr.enumerated() {
                if char == "(" {
                    start = i
                } else if char == ")" && start != -1 {
                    // Evaluate expression within parentheses
                    let startIndex = expr.index(expr.startIndex, offsetBy: start + 1)
                    let endIndex = expr.index(expr.startIndex, offsetBy: i)
                    let subExpr = String(expr[startIndex..<endIndex])
                    
                    if let result = evaluateSimple(subExpr) {
                        // Replace parentheses expression with result
                        let prefix = String(expr[..<expr.index(expr.startIndex, offsetBy: start)])
                        let suffix = String(expr[expr.index(expr.startIndex, offsetBy: i + 1)...])
                        return evaluateWithParentheses(prefix + String(result) + suffix)
                    }
                    return nil
                }
            }
            
            // If no parentheses, evaluate directly
            return evaluateSimple(expr)
        }
        
        // Helper function to evaluate simple expression without parentheses
        func evaluateSimple(_ expr: String) -> Double? {
            // Split into numbers and operators
            var numbers: [Double] = []
            var operators: [Character] = []
            var currentNum = ""
            
            for char in expr {
                if char.isNumber || char == "." {
                    currentNum.append(char)
                } else if "+-*/×÷".contains(char) {
                    if let num = Double(currentNum) {
                        numbers.append(num)
                    } else if currentNum.isEmpty && char == "-" {
                        currentNum = "-"
                        continue
                    }
                    currentNum = ""
                    operators.append(char)
                }
            }
            if let num = Double(currentNum) {
                numbers.append(num)
            }
            
            // Evaluate multiplication and division first
            var i = 0
            while i < operators.count {
                if "*/×÷".contains(operators[i]) {
                    if let result = calculate(numbers[i], numbers[i + 1], operators[i]) {
                        numbers.remove(at: i + 1)
                        numbers[i] = result
                        operators.remove(at: i)
                        i -= 1
                    } else {
                        return nil
                    }
                }
                i += 1
            }
            
            // Then evaluate addition and subtraction
            var result = numbers[0]
            for i in 0..<operators.count {
                if let nextResult = calculate(result, numbers[i + 1], operators[i]) {
                    result = nextResult
                } else {
                    return nil
                }
            }
            
            return result
        }
        
        return evaluateWithParentheses(expr)
    }
    
    // Test if a solution evaluates to 24
    func testSolution(_ solution: String) -> Bool {
        guard let result = evaluate(solution) else { return false }
        return abs(result - 24) < 0.0001  // Allow for small floating-point errors
    }
    
    // Extract numbers from a solution string
    func extractNumbers(from solution: String) -> [Int] {
        var numbers: [Int] = []
        var currentNum = ""
        
        for char in solution {
            if char.isNumber {
                currentNum.append(char)
            } else if !currentNum.isEmpty {
                if let num = Int(currentNum) {
                    numbers.append(num)
                }
                currentNum = ""
            }
        }
        
        // Don't forget the last number if there is one
        if !currentNum.isEmpty, let num = Int(currentNum) {
            numbers.append(num)
        }
        
        return numbers.sorted()
    }
    
    func testAllHandSolutions() {
        for hand in HandDataset.shared.hands {
            // Test if solution evaluates to 24
            XCTAssertTrue(
                testSolution(hand.solution),
                "Solution '\(hand.solution)' for hand \(hand.cards.map { String($0.value) }.joined(separator: ",")) does not evaluate to 24"
            )
            
            // Test if numbers in solution match hand numbers
            let solutionNumbers = extractNumbers(from: hand.solution)
            let handNumbers = hand.cards.map { $0.value }.sorted()
            
            XCTAssertEqual(
                solutionNumbers,
                handNumbers,
                "Numbers in solution '\(hand.solution)' do not match hand numbers \(handNumbers)"
            )
        }
    }
} 