//
//  Distribution.swift
//  
//
//  Created by 박재우 on 2023/08/12.
//

import Foundation

// equalSpacing is [o..o..o..o]
// evenSpacing is [..o..o..o..o..]
// aroundSpacing is [.o..o..o..o.]
public enum Distribution {
    case equalSpacing
    case evenSpacing
    case aroundSpacing

    var calibrationValue: Int {
        switch self {
        case .equalSpacing:
            return -1
        case .evenSpacing:
            return 1
        case .aroundSpacing:
            return 0
        }
    }
}
