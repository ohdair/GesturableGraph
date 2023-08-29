//
//  GesturableGraph+draw.swift
//
//
//  Created by 박재우 on 8/29/23.
//

import UIKit

extension GesturableGraph {
    func graphPath(through points: [CGPoint]) -> UIBezierPath? {
        switch type {
        case .curve:
            return UIBezierPath(quadCurve: points)
        case .straight:
            return UIBezierPath(straight: points)
        }
    }

    func draw(_ graph: UIBezierPath) {
        line.color.setStroke()
        graph.lineWidth = line.width
        graph.stroke()
    }

    func draw(_ points: [CGPoint]) {
        guard !point.isHidden else {
            return
        }

        point.color.setFill()
        points.forEach { point in
            drawPoint(point)
        }
    }

    private func drawPoint(_ point: CGPoint) {
        let diameter = self.point.width
        let radius = self.point.width / 2
        let pointRect = CGRect(x: point.x - radius, y: point.y - radius, width: diameter, height: diameter)
        let path = UIBezierPath(ovalIn: pointRect)
        path.fill()
    }

    func fillGraphArea(_ graphPath: UIBezierPath?, using points: [CGPoint]) {
        guard area.isFill,
              let clippingPath = graphPath?.copy() as? UIBezierPath,
              let firstPoint = points.first,
              let lastPoint = points.last
        else {
            return
        }

        clippingPath.addLine(to: CGPoint(x: lastPoint.x + line.width / 2, y: lastPoint.y))
        clippingPath.addLine(to: CGPoint(x: lastPoint.x + line.width / 2, y: bounds.maxY))
        clippingPath.addLine(to: CGPoint(x: firstPoint.x - line.width / 2, y: bounds.maxY))
        clippingPath.addLine(to: CGPoint(x: firstPoint.x - line.width / 2, y: firstPoint.y))
        clippingPath.close()
        clippingPath.addClip()

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let colors = area.colors
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: nil)
        else {
            return
        }

        let hightestYPoint = points.max { $0.y > $1.y }
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: hightestYPoint!.y),
            end: CGPoint(x: 0, y: bounds.maxY),
            options: [])
        context.restoreGState()
    }

    func convertToPoints(_ elements: [Double]) -> [CGPoint]? {
        guard elements.count > 1 else {
            return nil
        }

        return elements.enumerated()
            .compactMap { index, element in
                convertToPoint(from: element, ofIndex: index)
            }
    }

    private func convertToPoint(from element: Double, ofIndex index: Int) -> CGPoint {
        let x = calculateX(ofIndex: index)
        let y = calculateY(ofElement: element)

        return CGPoint(x: x, y: y)
    }

    private func calculateX(ofIndex index: Int) -> CGFloat {
        return bounds.width * (CGFloat(distribution.rawValue + 1) / 2 + CGFloat(index)) / CGFloat(elements.count + distribution.rawValue)
    }

    private func calculateY(ofElement element: Double) -> CGFloat {
        guard let calibrationTop = elements.calibrationTop(ofValue: verticalPadding.top),
              let calibrationBottom =  elements.calibrationBottom(ofValue: verticalPadding.bottom)
        else {
            return CGFloat()
        }

        return bounds.height / (calibrationTop - calibrationBottom) * (calibrationTop - element)
    }
}
