import XCTest
@testable import twentyfour

class HandGeneratorTests: XCTestCase {
    
    // Reuse the evaluation function from HandSolutionTests
    let solutionTester = HandSolutionTests()
    
    // All possible operators
    let operators = ["+", "-", "×", "÷"]
    
    // Generate all possible combinations of 4 numbers (1-13)
    func generateAllNumberCombinations() -> [[Int]] {
        var combinations: [[Int]] = []
        for a in 1...13 {
            for b in 1...13 {
                for c in 1...13 {
                    for d in 1...13 {
                        combinations.append([a, b, c, d])
                    }
                }
            }
        }
        return combinations
    }
    
    // Try all possible operator combinations and parentheses placements
    func findSolution(numbers: [Int]) -> String? {
        let nums = numbers.map { String($0) }
        
        // Try all permutations of the numbers
        let permutations = generatePermutations(nums)
        
        // Try all operator combinations
        for n1 in permutations {
            for op1 in operators {
                for op2 in operators {
                    for op3 in operators {
                        // Try different parentheses placements
                        let expressions = [
                            "(\(n1[0]) \(op1) \(n1[1])) \(op2) (\(n1[2]) \(op3) \(n1[3]))",
                            "((\(n1[0]) \(op1) \(n1[1])) \(op2) \(n1[2])) \(op3) \(n1[3])",
                            "(\(n1[0]) \(op1) (\(n1[1]) \(op2) \(n1[2]))) \(op3) \(n1[3])",
                            "\(n1[0]) \(op1) ((\(n1[1]) \(op2) \(n1[2])) \(op3) \(n1[3]))",
                            "\(n1[0]) \(op1) (\(n1[1]) \(op2) (\(n1[2]) \(op3) \(n1[3])))",
                            // Add more patterns to catch all possibilities
                            "\(n1[0]) \(op1) \(n1[1]) \(op2) \(n1[2]) \(op3) \(n1[3])",
                            "(\(n1[0]) \(op1) \(n1[1]) \(op2) \(n1[2])) \(op3) \(n1[3])",
                            "\(n1[0]) \(op1) (\(n1[1]) \(op2) \(n1[2]) \(op3) \(n1[3]))"
                        ]
                        
                        for expr in expressions {
                            if solutionTester.testSolution(expr) {
                                return expr
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    // Generate all permutations of an array
    func generatePermutations(_ arr: [String]) -> [[String]] {
        if arr.count <= 1 { return [arr] }
        
        var result: [[String]] = []
        var used = Set<[String]>()  // To avoid duplicate permutations
        
        for i in 0..<arr.count {
            let num = arr[i]
            var remaining = arr
            remaining.remove(at: i)
            
            let perms = generatePermutations(remaining)
            for var perm in perms {
                perm.insert(num, at: 0)
                if !used.contains(perm) {
                    used.insert(perm)
                    result.append(perm)
                }
            }
        }
        
        return result
    }
    
    // Assess difficulty of a solution
    func assessDifficulty(_ numbers: [Int], _ solution: String) -> Difficulty {
        // Count unique numbers
        let uniqueCount = Set(numbers).count
        
        // Check for division operations
        let hasDivision = solution.contains("÷")
        
        // Check for nested parentheses
        let nestedParentheses = solution.components(separatedBy: "(").count > 2
        
        // Check for negative intermediates (rough heuristic)
        let potentialNegative = solution.contains(") -") || solution.contains("- (")
        
        if hasDivision && nestedParentheses && potentialNegative {
            return .hard
        } else if hasDivision || nestedParentheses || uniqueCount < 3 {
            return .medium
        } else {
            return .easy
        }
    }
    
    // Test to generate and verify all possible hands
    func testGenerateAllHands() {
        var validHands: [(numbers: [Int], solution: String)] = []
        var seenCombinations = Set<String>() // To track unique combinations
        let combinations = generateAllNumberCombinations()
        var count = 0
        
        print("Starting generation...")
        
        for numbers in combinations {
            count += 1
            if count % 1000 == 0 {
                print("Processed \(count) combinations...")
            }
            
            // Sort numbers to create a unique key
            let sortedKey = numbers.sorted().map(String.init).joined(separator: ",")
            if seenCombinations.contains(sortedKey) {
                continue
            }
            
            if let solution = findSolution(numbers: numbers) {
                validHands.append((numbers: numbers, solution: solution))
                seenCombinations.insert(sortedKey)
            }
        }
        
        // Sort hands by difficulty and numbers for better organization
        let sortedHands = validHands.sorted { h1, h2 in
            let n1 = h1.numbers.sorted()
            let n2 = h2.numbers.sorted()
            return n1.lexicographicallyPrecedes(n2)
        }
        
        print("\nFound \(sortedHands.count) unique valid hands!")
        print("\nlet dataset: [(numbers: [Int], solution: String, difficulty: Difficulty)] = [")
        for hand in sortedHands {
            let difficulty = assessDifficulty(hand.numbers, hand.solution)
            print("    (\(hand.numbers), \"\(hand.solution)\", .\(difficulty)),")
        }
        print("]")
    }
} 