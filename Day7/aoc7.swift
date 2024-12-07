// swiftc aoc7.swift && ./aoc7
import Foundation

// Day 7 of AOC 2024
print("Day 7 of AOC 2024")

// Part 1 & 2
print("Part 1 & 2")

let file_path = "./input.txt"
let file = try String(contentsOfFile: file_path, encoding: .utf8)
var sum_retarded = 0
var sum_retarded_concat = 0
for line in file.split(separator: "\n") {
    //print("Line: \(line)")
    let line_s = line.split(separator: ":")
    let result = Int(line_s[0])!
    let operands_s = line_s[1].split(separator: " ")
    let operands = operands_s.compactMap{ Int($0)! }
    
    //print("Result: \(result)")
    //print("Operands str: \(operands_s)")
    //print("Operands: \(operands)")

    if (check_mul_add_retarded(result: result, prev: 0, operands: operands, start: 0)) {
        //print("Line: \(line) is retarded")
        sum_retarded += result
    }

    if (check_mul_add_retarded_concat(result: result, prev: 0, operands: operands, start: 0)) {
        //print("Line: \(line) is retarded")
        sum_retarded_concat += result
    }
}

print("Retarded sum is: \(sum_retarded)")
print("Retarded concatenated sum is: \(sum_retarded_concat)")

// check according to real addition and multiplication rules
func check_mul_add_real(result: Int, operands: [Int], start: Int) -> Bool {
    //print("res: \(result), operands: \(operands), start: \(start), oc: \(operands.count)")
    // check if result is positive
    if (result < 0) {
        return false;

    // base cases
    } else if (start == operands.count) {
        return result == 0;
    } else if (start == operands.count - 1) {
        return result == operands[start]

    // iterative
    } else {
        var mult = 1
        var flag = 1
        for i in start..<operands.count {
            mult = mult * operands[i]
            if (check_mul_add_real(result: result - mult, operands: operands, start: i + 1)) {
                flag = 0
                break
            }
        }
        return flag == 0
    }
}

// check according to retarded addition and multiplication rules
func check_mul_add_retarded(result: Int, prev: Int, operands: [Int], start: Int) -> Bool {
    //print("res: \(result), prev: \(prev) operands: \(operands), start: \(start), oc: \(operands.count)")
    // base case
    if (start == operands.count) {
        return prev == result;

    // iterative
    } else {
        if (check_mul_add_retarded(result: result, prev: prev + operands[start], operands: operands, start: start + 1)) {
            return true
        }
        if (check_mul_add_retarded(result: result, prev: prev * operands[start], operands: operands, start: start + 1)) {
            return true
        }
        return false
    }
}

//let check_real = check_mul_add_real(result: 292, operands: [11, 6, 16, 20], start: 0)
//print("check_real: \(check_real)")

//let check_retarded = check_mul_add_retarded(result: 292, prev: 0, operands: [11, 6, 16, 20], start: 0)
//print("check_retarded: \(check_retarded)")

// digits in integer
func digits_in_int(int: Int) -> Int {
    var n = int
    var c = 0
    while n != 0 {
        n = n / 10
        c += 1
    }
    return c
}

// get integer power of ten, because pow() function sucks
func pow_ten(exp: Int) -> Int {
    if (exp == 0) {
        return 1
    }
    var r = 10
    var e = exp
    while e != 1 {
        r = r * 10
        e -= 1
    }
    return r
}

// check according to retarded addition, multiplication and concatination rules
func check_mul_add_retarded_concat(result: Int, prev: Int, operands: [Int], start: Int) -> Bool {
    //print("res: \(result), prev: \(prev) operands: \(operands), start: \(start), oc: \(operands.count)")
    // base case
    if (start == operands.count) {
        return prev == result;

    // iterative
    } else {
        if (check_mul_add_retarded_concat(result: result, prev: prev + operands[start], operands: operands, start: start + 1)) {
            return true
        }
        if (check_mul_add_retarded_concat(result: result, prev: prev * operands[start], operands: operands, start: start + 1)) {
            return true
        }
        if (check_mul_add_retarded_concat(result: result, prev: pow_ten(exp: digits_in_int(int: operands[start])) * prev + operands[start], operands: operands, start: start + 1)) {
            return true
        }
        return false
    }
}






