//
//  VerticalPadding.swift
//  
//
//  Created by 박재우 on 2023/08/12.
//

import Foundation

// 0 means there is no separation
// Increases in percentage based on the height of the graph.
// The default value for top is 30 and bottom is 30.
struct VerticalPadding {
    var top: Double = 0.3
    var bottom: Double = 0.3
}
