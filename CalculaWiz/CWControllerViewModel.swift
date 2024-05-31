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
    private(set) lazy var CWHeaderLabel: String = (self.firstNumber ?? 0).description
    private(set) var currentNumber: CurrentNumber = .firstNumber
    
    private(set) var firstNumber: Int? = nil { didSet {
    self.CWHeaderLabel = self.firstNumber?.description ?? "0" } }
    private(set) var secondNumber: Int? = nil { didSet {
    self.CWHeaderLabel = self.secondNumber?.description ?? "0" } }
    private(set) var operation: LogicOperations? = nil
    
    private(set) var firstNumberIsDecimal: Bool = false
    private(set) var secondNumberIsDecimal: Bool = false
    
    //MARK: - Memory Varriables
    private(set) var previousNumber: Int? = nil
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
        self.currentNumber = .firstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.operation = nil
        self.previousNumber = nil
        self.previousOperation = nil
    }
}

extension CWControllerViewModel {
    private func didSelectNumber(with number: Int) {
        if self.currentNumber == .firstNumber {
            
            if let firstNumber = self.firstNumber {
                var firstNumberString = firstNumber.description
                firstNumberString.append(number.description)
                self.firstNumber = Int(firstNumberString)
                self.previousNumber = Int(firstNumberString)
            }
            else { self.firstNumber = Int(number)
                self.previousNumber = Int(number)}
        }
        else {
            if let secondNumber = self.secondNumber {
                var secondNumberString = secondNumber.description
                secondNumberString.append(number.description)
                self.secondNumber = Int(secondNumberString)
                self.previousNumber = Int(secondNumberString)
            } else {
                self.secondNumber = Int(number)
                self.previousNumber = Int(number)
            }
            
            
        }
    }
}
   //MARK: - Equals & Arithmetic Operations
extension CWControllerViewModel {
    private func didSelectEqualsButton() {
        if let operation = self.operation, let firstNumber = self.firstNumber, let secondNumber = self.secondNumber {
            // Equals is pressed normally after firstnumber, then an operation, then a secondnumber
            let result = self.getOperationResult(operation, firstNumber, secondNumber)
            self.secondNumber = nil
            self.previousOperation = operation
            self.operation = nil
            self.firstNumber = result
            self.currentNumber = .firstNumber
        } else if let previousOperation = self.previousOperation, let firstNumber = self.firstNumber, let previousNumber = self.previousNumber {
            // This will update the calculated based on previously selected number and arithmatic operation
            let result = self.getOperationResult(previousOperation, firstNumber, previousNumber)
            self.firstNumber = result
        }
    }
    
    private func didSelectOperation(with operation: LogicOperations ) {
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
        } else if self.currentNumber == .secondNumber {
            if let previousOperation = self.operation , let firstNumber = self.firstNumber, let secondNumber = self.secondNumber {
                let result = self.getOperationResult(previousOperation, firstNumber, secondNumber)
                self.secondNumber = nil
                self.firstNumber = result
                self.currentNumber = .secondNumber
                self.operation = operation
            } else {
                self.operation = operation
            }
        }
        
        
        
    }
    // MARK: - Operation Helper
    private func getOperationResult (_ operation: LogicOperations, _ firstNumber: Int, _ secondNumber: Int) -> Int {
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
            number.negate()
            self.firstNumber = number
            self.previousNumber = number
        } else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            number.negate()
            self.secondNumber = number
            self.previousNumber = number
        }
    }
    private func didSelectPercentage() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber {
            number /= 100
            self.firstNumber = number
            self.previousNumber = number
        }
        else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            number /= 100
            self.secondNumber = number
            self.previousNumber = number
        }
    }
    private func didSelectDecimal() {
        if self.currentNumber == .firstNumber { self.firstNumberIsDecimal = true }
        else if self.currentNumber == .secondNumber { self.secondNumberIsDecimal = true }
    }
}
