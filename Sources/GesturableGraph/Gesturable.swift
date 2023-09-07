//
//  Gesturable.swift
//
//
//  Created by 박재우 on 9/1/23.
//

import Foundation

protocol Gesturable {
    var gesture: CGPoint? { get set }
}

extension Gesturable {
    func calculatedPoint(in graph: Graph, withSize size: CGRect) -> CGPoint? {
        let pointsOnGraph = graph.points.map { (x, y) in
            CGPoint(x: size.width * x, y: size.height * y)
        }

        guard isIncludedGesture(usingPoints: pointsOnGraph) else {
            return nil
        }

        return contactPoint(ofTypeGraph: graph.type, usingPoints: pointsOnGraph)
    }
    
    private func isIncludedGesture(usingPoints points: [CGPoint]) -> Bool {
        guard let gesture,
              let firstPoint = points.first,
              let lastPoint = points.last,
              gesture.x > firstPoint.x,
              gesture.x < lastPoint.x else {
            return false
        }

        return true
    }

    private func contactPoint(ofTypeGraph type: Graph.GraphType, usingPoints points: [CGPoint]) -> CGPoint {
        switch type {
        case .curve:
            return contactPointOfCurveGraph(accordingToPoints: points)
        case .straight:
            return contactPointOfStraightGraph(accordingToPoints: points)
        }
    }

    private func contactPointOfStraightGraph(accordingToPoints points: [CGPoint]) -> CGPoint {
        guard let gesture,
              let index = points.lastIndex(where: { $0.x < gesture.x }) else {
            fatalError("This is an error that should not occur.")
        }

        let p0 = points[index]
        let p1 = points[index + 1]
        let slope = (p1.y - p0.y) / (p1.x - p0.x)
        let intercept = p0.y - slope * p0.x

        return CGPoint(x: gesture.x, y: slope * gesture.x + intercept)
    }

    private func contactPointOfCurveGraph(accordingToPoints points: [CGPoint]) -> CGPoint {
        guard let gesture,
              let index = points.lastIndex(where: { $0.x < gesture.x }) else {
            fatalError("This is an error that should not occur.")
        }

        let midPoint = points[index + 1].midPoint(from: points[index])
        let p2 = midPoint
        let p0 = gesture.x > midPoint.x ? points[index + 1] : points[index]
        let y = cacultatedY(pointX: gesture.x, p0: p0, p2: p2)

        return CGPoint(x: gesture.x, y: y)
    }

    private func cacultatedY(pointX: Double, p0: CGPoint, p2: CGPoint) -> Double {
        let p1 = p0.controlPoint(from: p2)
        let t = (pointX - p0.x) / (p2.x - p0.x)
        return pow(1 - t, 2) * p0.y + 2 * (1 - t) * t * p1.y + pow(t, 2) * p2.y
    }
}
