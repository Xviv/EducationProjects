//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by Dan on 19/11/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    
    private var number:Double?
    private var intermediateCalculation: (number: Double, operation: String)?
    
    mutating func setNumber(_ number: Double) {
        self.number = number
    }
    
    mutating func calculationLogic(symbol: String) -> Double? {
        
        if let n = number {
            
            switch symbol {
            case "+/-":
                return n * -1 // Меняет знак на противоположный
            case "AC":
                return 0
            case "%":
                return n * 0.01 // Равно делению на 100
            case "=":
                return performTwoNumbersCalculation(n2: n)
            default:
                intermediateCalculation = (number: n, operation: symbol)
            }            
        }
        return nil
    }
    private func performTwoNumbersCalculation(n2: Double) -> Double? {
        if let n1 = intermediateCalculation?.number,
            let operation = intermediateCalculation?.operation {

            switch operation {
            case "+":
                return n1 + n2
            case "-":
                return n1 - n2
            case "×":
                return n1 * n2
            case "÷":
                return n1 / n2
            default:
                fatalError("The operation passed in does not match any of the cases")
            }
        }
        return nil
    }
}
