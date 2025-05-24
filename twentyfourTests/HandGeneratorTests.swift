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
        
        // Helper function to count unique operators
        func countOperators(_ expr: String) -> (total: Int, divideCount: Int, minusCount: Int) {
            let divCount = expr.components(separatedBy: "÷").count - 1
            let minCount = expr.components(separatedBy: "-").count - 1
            let uniqueOps = Set(expr.filter { "+-×÷".contains($0) }).count
            return (uniqueOps, divCount, minCount)
        }
        
        // Helper function to score an expression (lower is better)
        func scoreExpression(_ expr: String) -> Int {
            let bracketCount = expr.components(separatedBy: "(").count - 1
            let (uniqueOps, divCount, minCount) = countOperators(expr)
            
            // Scoring weights:
            // - Each bracket: 2 points
            // - Each unique operator type: 3 points
            // - Each division: 4 points
            // - Each subtraction: 3 points
            return bracketCount * 2 + uniqueOps * 3 + divCount * 4 + minCount * 3
        }
        
        var bestSolution: String? = nil
        var bestScore = Int.max
        
        // Try all operator combinations
        for n1 in permutations {
            // Try simpler operations first
            let operatorSets: [[String]] = [
                // Level 1: Single operator type
                ["×"], ["+"], ["-"], ["÷"],  // all possible single operators
                
                // Level 2: Two operator types (prioritize simpler combinations)
                ["+", "-"],  // addition and subtraction
                ["×", "+"],  // multiplication and addition
                ["×", "-"],  // multiplication and subtraction
                ["×", "÷"],  // multiplication and division
                ["+", "÷"],  // addition and division
                ["-", "÷"],  // subtraction and division
                
                // Level 3: Three operator types
                ["×", "+", "-"],  // no division
                ["+", "-", "÷"],  // no multiplication
                ["×", "+", "÷"],  // no subtraction
                ["×", "-", "÷"],  // no addition
                
                // Level 4: All operators
                ["+", "-", "×", "÷"]
            ]
            
            for operators in operatorSets {
                for op1 in operators {
                    for op2 in operators {
                        for op3 in operators {
                            // Try expressions in order of complexity
                            let expressions = [
                                // Level 1: No brackets
                                "\(n1[0]) \(op1) \(n1[1]) \(op2) \(n1[2]) \(op3) \(n1[3])",
                                
                                // Level 2: One pair of brackets
                                "(\(n1[0]) \(op1) \(n1[1])) \(op2) \(n1[2]) \(op3) \(n1[3])",
                                "\(n1[0]) \(op1) (\(n1[1]) \(op2) \(n1[2])) \(op3) \(n1[3])",
                                "\(n1[0]) \(op1) \(n1[1]) \(op2) (\(n1[2]) \(op3) \(n1[3]))",
                                
                                // Level 3: Two pairs of brackets
                                "(\(n1[0]) \(op1) \(n1[1])) \(op2) (\(n1[2]) \(op3) \(n1[3]))",
                                
                                // Level 4: Nested brackets
                                "((\(n1[0]) \(op1) \(n1[1])) \(op2) \(n1[2])) \(op3) \(n1[3])",
                                "(\(n1[0]) \(op1) (\(n1[1]) \(op2) \(n1[2]))) \(op3) \(n1[3])",
                                "\(n1[0]) \(op1) ((\(n1[1]) \(op2) \(n1[2])) \(op3) \(n1[3]))",
                                "\(n1[0]) \(op1) (\(n1[1]) \(op2) (\(n1[2]) \(op3) \(n1[3])))"
                            ]
                            
                            for expr in expressions {
                                if solutionTester.testSolution(expr) {
                                    let score = scoreExpression(expr)
                                    if score < bestScore {
                                        bestScore = score
                                        bestSolution = expr
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return bestSolution
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
            print("    (\(hand.numbers), \"\(hand.solution)\", .easy),")
        }
        print("]")
    }
} 