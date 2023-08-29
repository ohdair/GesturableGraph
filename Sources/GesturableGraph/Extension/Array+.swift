//
//  Array+.swift
//
//
//  Created by 박재우 on 8/29/23.
//

import Foundation

extension Array where Element == Double {
    func calibrationTop(ofValue top: Double) -> Double? {
        guard let max = self.max(),
              let min = self.min()
        else {
            return nil
        }

        return max + ((max - min) * top)
    }

    func calibrationBottom(ofValue bottom: Double) -> Double? {
        guard let max = self.max(),
              let min = self.min()
        else {
            return nil
        }

        return min - ((max - min) * bottom)
    }
}
