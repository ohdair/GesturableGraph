//
//  Constraints.swift
//
//
//  Created by 박재우 on 8/29/23.
//

import UIKit

struct Constraints {
    static let lineWidth = 2.0
    static let lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    static let pointWidth = 4.0
    static let pointColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    static let pointIsHidden = false

    static let areaColors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)]
    static let areaIsFill = true

    static let topOfPadding = 0.3
    static let bottomOfPadding = 0.3

    static let enableLineWidth = 4.0
    static let enableLineColor = #colorLiteral(red: 1, green: 0.6745654941, blue: 0.1722558439, alpha: 1)
    static let enablePointWidth = 10.0
    static let enablePointColor = #colorLiteral(red: 0.8782253861, green: 0.8383012414, blue: 0.8147805333, alpha: 1)

    static let AxisYDivision = 8

    static let gapHeight = UIFont.preferredFont(forTextStyle: .caption1).lineHeight / 2
}
