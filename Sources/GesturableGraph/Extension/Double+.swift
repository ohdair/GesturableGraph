//
//  Double+.swift
//
//
//  Created by 박재우 on 11/3/23.
//

import Foundation

extension Double {
    func formatDouble(decimalPlaces: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = decimalPlaces

        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
