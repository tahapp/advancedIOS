//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by ben hussain on 11/30/23.
//

import Foundation
final class CalculatorBrain
{
    
    private enum Operands
    {
        
        case BinaryOperation(String,(Double,Double)->Double)
        case UniaryOperation(String,(Double)->Double)
        case enter(String)
    }
    private var internalProgram = [Any]()
    private struct PendingBinaryOperationInfo
    {
        var binaryFunction : (Double,Double)->Double
        var firstOperand:Double
    }
    private var operands : [Operands] = []
    
    
    var accumulator = 0.0
    private var pending: PendingBinaryOperationInfo?
    private var knownOperations: [String:Operands] = [
        "+": .BinaryOperation("+", {$0 + $1}),
        "-": .BinaryOperation("-", {$0 - $1}),
        "/": .BinaryOperation("/", {$0 / $1}),
        "*": .BinaryOperation("*", {$0 * $1}),
        "cos": .UniaryOperation("cos", {cos($0)}),
        "sin": .UniaryOperation("sin", {sin($0)}),
        "tan": .UniaryOperation("tan", {tan($0)}),
        ButtonSymbols.enter: .enter(ButtonSymbols.enter),
        ButtonSymbols.sqaure: .UniaryOperation(ButtonSymbols.sqaure, {sqrt($0)} )
        
    ]
    
    typealias propertyList = Any
    
    var program: propertyList
    {
        get
        {
            return internalProgram
        }
        set
        {
            clear()
            if let ops = newValue as? [Any]
            {
                for op in ops
                {
                    if let operand = op as? Double
                    {
                        appendDigit(operand)
                    }
                    if let symbol = op as? String
                    {
                        performOperation(symbol)
                    }
                }
            }
        }
    }
    
    func clear()
    {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
   
     func appendDigit(_ digit: Double)
    {
        accumulator = digit
        internalProgram.append(digit)
    }
    
    func performOperation(_ symbol:String)
    {
        internalProgram.append(symbol)
        if let operation = knownOperations[symbol]
        {
            switch operation
            {
          
            case .UniaryOperation(_, let function):
                accumulator = function(accumulator)
            case .BinaryOperation(_, let function):
                
                if pending != nil
                {
                    accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
                }
                
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .enter(_):
                if pending != nil
                {
                    accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
                }
                pending = nil
            }
        }
       
    }

}

