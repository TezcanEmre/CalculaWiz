//
//  CWButton.swift
//  CalculaWiz
//
//  Created by Perseus on 24.05.2024.
//

import UIKit
enum CWButton {
    case ACButton, plusMinus, percentage, divide, multiply, subtract, add, equals, decimal, number(Int), backspace
    init(CWButtons: CWButton) {
        switch CWButtons {
        case .ACButton, .plusMinus, .percentage, .divide, .multiply, .subtract, .add, .equals, .backspace:
            self = CWButtons
        case .number(let int):
            if int.description.count == 1 {
                self = CWButtons
            }
            else { fatalError("Int is not 1 digit") }
        case .decimal:
            self = CWButtons
        }
    }
}
extension CWButton {
    var title: String {
        switch self {
        case .ACButton:
            return "AC"
        case .plusMinus:
            return "+/-"
        case .percentage:
            return "%"
        case .divide:
            return "÷"
        case .multiply:
            return "x"
        case .subtract:
            return "-"
        case .add:
            return "+"
        case .equals:
            return "="
        case .number(let int):
            return int.description
        case .decimal:
            return "."
        case .backspace:
            return ""
        } }
    var colors: UIColor {
        switch self {
        case .ACButton, .plusMinus, .percentage, .divide, .multiply, .subtract, .add, .equals,.number, .decimal,.backspace:
            return .buttonRenk
        }
    }
    var selectedColor: UIColor? {
        switch self {
        case .ACButton, .plusMinus, .percentage, .equals, .number, .decimal, .divide, .multiply, .subtract, .add,.backspace:
            return .buttonClickedRenk
        }
    }
    var icon: UIImage? {
        switch self {
        case .backspace:
            return UIImage(named:"backspaceIcon")
        default:
            return nil
        }
    }
    
    
}

