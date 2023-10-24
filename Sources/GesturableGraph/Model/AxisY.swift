//
//  AxisY.swift
//
//
//  Created by 박재우 on 10/20/23.
//

import Foundation

public struct AxisY {
    public var dataUnit: String = ""
    public var division: Int = Constraints.AxisYDivision
    public var decimalPlaces: Int = 0

    public var position: Position = .right

    public enum Position {
        case left
        case right
    }
}
