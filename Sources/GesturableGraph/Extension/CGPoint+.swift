//
//  CGPoint+.swift
//
//
//  Created by 박재우 on 9/5/23.
//

import Foundation

extension CGPoint {
    func midPoint(from point: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x + point.x) / 2, y: (self.y + point.y) / 2)
    }

    func controlPoint(from point: CGPoint) -> CGPoint {
        return CGPoint(x: midPoint(from: point).x, y: self.y)
    }
}
