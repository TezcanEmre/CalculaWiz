import Foundation

enum CurrentNumber {
    case firstNumber
    case secondNumber
}

class CWControllerViewModel {
    
    var updateView: (() -> Void)?
    
    // MARK: - TableView DataSource Array
    let CWButtonCells: [CWButton] = [
        .ACButton, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .backspace, .equals
    ]
    
    // MARK: - Variables
    private(set) lazy var CWHeaderLabel: String = self.firstNumber ?? "0"
    private(set) var currentNumber: CurrentNumber = .firstNumber
    
    private(set) var firstNumber: String? = nil {
        didSet {
            self.CWHeaderLabel = self.firstNumber?.description ?? "0"
        }
    }
    private(set) var secondNumber: String? = nil {
        didSet {
            self.CWHeaderLabel = self.secondNumber?.description ?? "0"
        }
    }
    private(set) var operation: LogicOperations? = nil
    var errorStatement : Bool = false
    
    // MARK: - Memory Variables
    private(set) var previousNumber: String? = nil
    private(set) var previousOperation: LogicOperations? = nil
    
    // MARK: - Selecting Numbers
    public func didSelectButton(with CalcButton: CWButton) {
        switch CalcButton {
        case .ACButton:
            self.didSelectAC()
        case .plusMinus:
            self.didSelectPlusMinus()
        case .percentage:
            self.didSelectPercentage()
        case .divide:
            self.didSelectOperation(with: .divide)
        case .multiply:
            self.didSelectOperation(with: .multiply)
        case .subtract:
            self.didSelectOperation(with: .subtract)
        case .add:
            self.didSelectOperation(with: .add)
        case .equals:
            self.didSelectEqualsButton()
        case .decimal:
            self.didSelectDecimal()
        case .number(let number):
            self.didSelectNumber(with: number)
        case .backspace:
            self.backspaceButton()
        }
        self.updateView?()
    }
    
    private func didSelectAC() {
        self.CWHeaderLabel = "0"
        self.currentNumber = .firstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.operation = nil
        self.previousNumber = nil
        self.previousOperation = nil
    }
    
    private func didSelectNumber(with number: Int) {
        if self.currentNumber == .firstNumber {
            if var firstNumber = self.firstNumber {
                firstNumber.append(number.description)
                self.firstNumber = firstNumber
                self.previousNumber = firstNumber
            } else {
                self.firstNumber = number.description
                self.previousNumber = number.description
            }
        } else {
            if var secondNumber = self.secondNumber {
                secondNumber.append(number.description)
                self.secondNumber = secondNumber
                self.previousNumber = secondNumber
            } else {
                self.secondNumber = number.description
                self.previousNumber = number.description
            }
        }
    }
    
    // MARK: - Equals & Arithmetic Operations
    private func didSelectEqualsButton() {
        if let operation = self.operation, let firstNumber = self.firstNumber?.toDouble, let secondNumber = self.secondNumber?.toDouble {
            let result = self.getOperationResult(operation, firstNumber, secondNumber)
            let resultString : String
            if result.truncatingRemainder(dividingBy: 1) != 0 { resultString = result.description }
            else { resultString = result.toInt?.description ?? "Error"  }
            self.secondNumber = nil
            self.previousOperation = operation
            self.operation = nil
            self.firstNumber = resultString
            self.currentNumber = .firstNumber
        } else if let previousOperation = self.previousOperation, let firstNumber = self.firstNumber?.toDouble, let previousNumber = self.previousNumber?.toDouble {
            let result = self.getOperationResult(previousOperation, firstNumber, previousNumber)
            let resultString = result.description
            self.firstNumber = resultString
        }
        if errorStatement == true {
            self.firstNumber = "Error"
            errorStatement = false
        }
    }
    
    private func didSelectOperation(with operation: LogicOperations) {
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
        } else if self.currentNumber == .secondNumber {
            if let previousOperation = self.operation, let firstNumber = self.firstNumber?.toDouble, let secondNumber = self.secondNumber?.toDouble {
                let result = self.getOperationResult(previousOperation, firstNumber, secondNumber)
                let resultString = result.description
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
    private func getOperationResult(_ operation: LogicOperations, _ firstNumber: Double?, _ secondNumber: Double?) -> Double {
        guard let firstNumber = firstNumber, let secondNumber = secondNumber else { return 0 }
        switch operation {
        case .divide:
            if firstNumber == 0 && secondNumber == 0 {
                errorStatement = true
                return 0
            } else if secondNumber == 0 {
                return 0
            } else
            { return (firstNumber / secondNumber) }
            
        case .multiply:
            return (firstNumber * secondNumber)
        case .subtract:
            return (firstNumber - secondNumber)
        case .add:
            return (firstNumber + secondNumber)
        }
    }
    
    // MARK: - Action Buttons
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
            else {
                self.firstNumber = number.description
            }
        } else if self.currentNumber == .secondNumber, var number = self.secondNumber?.toDouble {
            number /= 100
            if number.isInt { self.secondNumber = number.toInt?.description }
            else {
                self.secondNumber = number.description
            }
        }
    }
    
    private func didSelectDecimal() {
        if self.currentNumber == .firstNumber {
            if let firstNumber = self.firstNumber, !firstNumber.contains(".") {
                self.firstNumber = firstNumber.appending(".")
            } else if self.firstNumber == nil {
                self.firstNumber = "0."
            }
        } else if self.currentNumber == .secondNumber {
            if let secondNumber = self.secondNumber, !secondNumber.contains(".") {
                self.secondNumber = secondNumber.appending(".")
            } else if self.secondNumber == nil {
                self.secondNumber = "0."
            }
        }
    }
    
    private func backspaceButton() {
        if self.currentNumber == .firstNumber {
            if var number = self.firstNumber, !number.isEmpty {
                number.removeLast()
                self.firstNumber = number.isEmpty ? nil : number
            }
        } else if self.currentNumber == .secondNumber {
            if var number = self.secondNumber, !number.isEmpty {
                number.removeLast()
                self.secondNumber = number.isEmpty ? nil : number
            }
        }
    }
}
