//
//  extensions.swift
//  CalculaWiz
//
//  Created by Perseus on 27.05.2024.
//

import Foundation

extension Double {
    var toInt: Int? {
        return Int(self)
    }
}
extension String {
    var toDouble: Double? {
        return Double(self)
    }
}
extension FloatingPoint {
    var isInt: Bool { return rounded() == self}
}
