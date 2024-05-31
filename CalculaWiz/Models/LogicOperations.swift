//
//  LogicOperations.swift
//  CalculaWiz
//
//  Created by Perseus on 27.05.2024.
//

import Foundation

enum LogicOperations {
    case divide, multiply, subtract, add
    
    var title: String {
        switch self {
        case .divide:
            return "÷"
        case .multiply:
            return "x"
        case .subtract:
            return "-"
        case .add:
            return "+"
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
