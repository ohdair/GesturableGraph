//
//  UIBezierPath+.swift
//
//
//  Created by 박재우 on 8/29/23.
//

import UIKit

extension UIBezierPath {
    convenience init?(straight points: [CGPoint]) {
        guard points.count > 1 else {
            return nil
        }

        self.init()

        move(to: points[0])

        for i in 1..<points.count {
            addLine(to: points[i])
        }

        lineCapStyle = .round
        lineJoinStyle = .round
    }

    convenience init?(quadCurve points: [CGPoint]) {
        guard points.count > 1 else {
            return nil
        }

        self.init()

        var p0 = points[0]
        move(to: p0)

        for i in 1..<points.count {
            let p2 = midPoint(from: p0, to: points[i])

            addQuadCurve(to: p2, controlPoint: controlPoint(p0: p0, p2: p2))
            addQuadCurve(to: points[i], controlPoint: controlPoint(p0: points[i], p2: p2))

            p0 = points[i]
        }

        lineCapStyle = .round
        lineJoinStyle = .round
    }

    func pointYOfCurveGraph(from pointX: Double, points: [CGPoint]) -> Double? {
        guard let firstIndex = points.lastIndex(where: { $0.x < pointX }) else {
            return nil
        }

        let midPoint = midPoint(from: points[firstIndex], to: points[firstIndex + 1])
        let p2 = pointX > midPoint.x ? midPoint : points[firstIndex]
        let p0 = pointX > midPoint.x ? points[firstIndex] : midPoint

        return cacultatedY(pointX: pointX, p0: p0, p2: p2)
    }

    func pointYOfStraightGraph(from pointX: Double, points: [CGPoint]) -> Double? {
        guard let firstIndex = points.lastIndex(where: { $0.x < pointX }) else {
            return nil
        }

        let p0 = points[firstIndex]
        let p1 = points[firstIndex + 1]

        let slope = (p1.y - p0.y) / (p1.x - p0.x)
        let intercept = p0.y - slope * p0.x

        return slope * pointX + intercept
    }

    private func cacultatedY(pointX: Double, p0: CGPoint, p2: CGPoint) -> Double {
        let p1 = controlPoint(p0: p0, p2: p2)
        let t = (pointX - p0.x) / (p2.x - p0.x)
        return pow(1 - t, 2) * p0.y + 2 * (1 - t) * t * p1.y + pow(t, 2) * p2.y
    }

    private func midPoint(from p1: CGPoint, to p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }

    private func controlPoint(p0: CGPoint, p2: CGPoint) -> CGPoint {
        var p1 = midPoint(from: p0, to: p2)
        p1.y = p0.y

        return p1
    }
}
