//
//  CWControllerViewModel.swift
//  CalculaWiz
//
//  Created by Perseus on 24.05.2024.
//

import Foundation

enum CurrentNumber {
    case firstNumber
    case secondNumber
}

class CWControllerViewModel {
    
    var updateView: (()->Void)?
    
    //MARK: - TableView DataSource Array
    let CWButtonCells: [CWButton] = [
        .ACButton, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .backspace, .equals]
//MARK: - Varriables
    private(set) lazy var CWHeaderLabel: String = self.firstNumber ?? "0"
    private(set) var currentNumber: CurrentNumber = .firstNumber
    
    private(set) var firstNumber: String? = nil { didSet {
    self.CWHeaderLabel = self.firstNumber?.description ?? "0" } }
    private(set) var secondNumber: String? = nil { didSet {
    self.CWHeaderLabel = self.secondNumber?.description ?? "0" } }
    private(set) var operation: LogicOperations? = nil
    
    private(set) var firstNumberIsDecimal: Bool = false
    private(set) var secondNumberIsDecimal: Bool = false
    var eitherNumberIsDecimal: Bool {
        return firstNumberIsDecimal || secondNumberIsDecimal
    }
    
    //MARK: - Memory Varriables
    private(set) var previousNumber: String? = nil
    private(set) var previousOperation: LogicOperations? = nil

}
// MARK: - Selecting Numbers
extension CWControllerViewModel {
    public func didSelectButton(with CalcButton: CWButton) {
        switch CalcButton {
        case .ACButton: self.didSelectAC()
        case .plusMinus: self.didSelectPlusMinus()
        case .percentage: self.didSelectPercentage()
        case .divide: self.didSelectOperation(with: .divide)
        case .multiply: self.didSelectOperation(with: .multiply)
        case .subtract: self.didSelectOperation(with: .subtract)
        case .add: self.didSelectOperation(with: .add)
        case .equals: self.didSelectEqualsButton()
        case .decimal: self.didSelectDecimal()
        case .number(let number):
            self.didSelectNumber(with: number)
        case .backspace:
            fatalError()
        }
        self.updateView?()
    }
    private func didSelectAC() {
        self.CWHeaderLabel = "0"
        self.currentNumber = .firstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.firstNumberIsDecimal = false
        self.secondNumberIsDecimal = false
        self.operation = nil
        self.previousNumber = nil
        self.previousOperation = nil
    }
}

extension CWControllerViewModel {
    private func didSelectNumber(with number: Int) {
        if self.currentNumber == .firstNumber {
            
            if var firstNumber = self.firstNumber {
                firstNumber.append(number.description)
                self.firstNumber = firstNumber
                self.previousNumber = firstNumber
                
//                var firstNumberString = firstNumber.description
//                firstNumberString.append(number.description)
//                self.firstNumber = Int(firstNumberString)
//                self.previousNumber = Int(firstNumberString)
            }
            else { self.firstNumber = number.description
                self.previousNumber = number.description}
        }
        else {
            if var secondNumber = self.secondNumber {
                secondNumber.append(number.description)
                self.secondNumber = secondNumber
                self.previousNumber = secondNumber
                
                //var secondNumberString = secondNumber.description
                //secondNumberString.append(number.description)
                //self.secondNumber = Int(secondNumberString)
                //self.previousNumber = Int(secondNumberString)
            } else {
                //self.secondNumber = Int(number)
                //self.previousNumber = Int(number)
                self.secondNumber = number.description
                self.previousNumber = number.description
            }
            
            
        }
    }
}
   //MARK: - Equals & Arithmetic Operations
extension CWControllerViewModel {
    private func didSelectEqualsButton() {
        if let operation = self.operation, let firstNumber = self.firstNumber?.toDouble, let secondNumber = self.secondNumber?.toDouble {
            // Equals is pressed normally after firstnumber, then an operation, then a secondnumber
            let result = self.getOperationResult(operation, firstNumber, secondNumber)
            let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
            self.secondNumber = nil
            self.previousOperation = operation
            self.operation = nil
            self.firstNumber = resultString
            self.currentNumber = .firstNumber
        } else if let previousOperation = self.previousOperation, let firstNumber = self.firstNumber?.toDouble, let previousNumber = self.previousNumber?.toDouble {
            // This will update the calculated based on previously selected number and arithmatic operation
            let result = self.getOperationResult(previousOperation, firstNumber, previousNumber)
            let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
            self.firstNumber = resultString
        }
    }
    
    private func didSelectOperation(with operation: LogicOperations ) {
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
        } else if self.currentNumber == .secondNumber {
            if let previousOperation = self.operation , let firstNumber = self.firstNumber?.toDouble, let secondNumber = self.secondNumber?.toDouble {
                let result = self.getOperationResult(previousOperation, firstNumber, secondNumber)
                let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description

                self.secondNumber = nil
                self.firstNumber = resultString
                self.currentNumber = .secondNumber
                self.operation = operation
            } else {
                self.operation = operation
            }
        }
        
        
        
    }
    // MARK: - Operation Helper
    private func getOperationResult (_ operation: LogicOperations, _ firstNumber: Double?, _ secondNumber: Double?) -> Double {
        guard let firstNumber = firstNumber, let secondNumber = secondNumber else { return 0 }
        switch operation {
        case .divide:
            return (firstNumber / secondNumber)
        case .multiply:
            return (firstNumber * secondNumber)
        case .subtract:
            return (firstNumber - secondNumber)
        case .add:
            return (firstNumber + secondNumber)
        }
    }
}
//MARK: - Action Buttons
extension CWControllerViewModel {
    private func didSelectPlusMinus() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber {
            if number.contains("-") { number.removeFirst() }
            else { number.insert("-", at: number.startIndex) }
            self.firstNumber = number
            self.previousNumber = number
        } else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            if number.contains("-") { number.removeFirst() }
            else { number.insert("-", at: number.startIndex) }
            self.secondNumber = number
            self.previousNumber = number
        }
    }
    private func didSelectPercentage() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber?.toDouble {
            number /= 100
            if number.isInt { self.firstNumber = number.toInt?.description }
            else { self.firstNumber = number.description
                self.firstNumberIsDecimal = true } }
        
        else if self.currentNumber == .secondNumber, var number = self.secondNumber?.toDouble {
            number /= 100
            if number.isInt { self.secondNumber = number.toInt?.description }
            else { self.secondNumber = number.description
                self.secondNumberIsDecimal = true }
            
        }
    }
    private func didSelectDecimal() {
        if self.currentNumber == .firstNumber {
            self.firstNumberIsDecimal = true
            if let firstNumber = self.firstNumber, !firstNumber.contains(".") {
                self.firstNumber = firstNumber.appending(".")
            } else if self.firstNumber == nil { self.firstNumber = "0." }
            
            
        }
        else if self.currentNumber == .secondNumber {
            self.secondNumberIsDecimal = true
            if let secondNumber = self.secondNumber, !secondNumber.contains(".") {
                self.secondNumber = secondNumber.appending(".")
            } else if self.secondNumber == nil { self.secondNumber = "0." }
            
        }
    }
}
