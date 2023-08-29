//
//  Array+.swift
//
//
//  Created by 박재우 on 8/29/23.
//

import Foundation

extension Array where Element == Double {
    func calibrationTop(ofValue top: Double) -> Double? {
        guard top >= 0,
              let max = self.max(),
              let min = self.min()
        else {
            return nil
        }

        if max == min {
            return max + (1 + top)
        }

        return max + ((max - min) * top)
    }

    func calibrationBottom(ofValue bottom: Double) -> Double? {
        guard bottom >= 0,
              let max = self.max(),
              let min = self.min()
        else {
            return nil
        }

        if max == min {
            return max - (1 + bottom)
        }

        return min - ((max - min) * bottom)
    }
}
