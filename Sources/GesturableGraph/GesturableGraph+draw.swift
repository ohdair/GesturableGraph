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

        let colors = convertColors(area.gradientColors)
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

    private func convertColors(_ colors: [UIColor]) -> [CGColor] {
        if colors.count == 1 {
            return colors.map { $0.cgColor } + colors.map { $0.cgColor }
        }

        return colors.map { $0.cgColor }
    }
}
