//
//  moDel.swift
//  miniCraftCal
//
//  Created by Nikhil Tanappagol on 6/21/17.
//  Copyright © 2017 Nikhil Tanappagol. All rights reserved.
//

import Foundation


enum CalcError: Error {
    case DivideByZero
}

struct CalculatorBrain {
    
    // optional on initialization = not set
    private var accumulator: Double?
    
    // private enum specifying operation types
    // with an associated value
    private enum Operation {
    
        case binary((Double,Double) -> Double)
        case equals
    }
    
    // private extensible dictionary of operations with closures
    private var operations: Dictionary<String,Operation> = [
    
        "×" : Operation.binary({ $0 * $1 }),
        "÷" : Operation.binary({ $0 / $1 }),
        "+" : Operation.binary({ $0 + $1 }),
        "−" : Operation.binary({ $0 - $1 }),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                 case .binary(let f):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    // Private mutating func for performing pending binary operations
    mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    // Private optional Pending Binary Operation
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    // embedded private struct to support binary operations
    // with a constant function and pending first operand
    // doesn't need mutating since its just returning a value
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // mark method as mutating in order to assign to property
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    // return an optional since the accumulator can be not set
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
