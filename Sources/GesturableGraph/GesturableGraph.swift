import UIKit

public class GesturableGraph: UIView {
    public let elements: [Double]
    public var distribution: Distribution
    public var type: GraphType
    public var line: GraphLine
    public var point: GraphPoint
    private var verticalPadding: VerticalPadding

    public init?(_ frame: CGRect = .zero, elements: [Double]) {
        guard elements.count > 1 else {
            return nil
        }

        self.elements = elements
        self.distribution = .equalSpacing
        self.type = .curve
        self.line = GraphLine()
        self.point = GraphPoint()
        self.verticalPadding = VerticalPadding()
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        let points = convertToPoints()
        drawGraph(through: points)
        drawPoints(points)
    }

    private func drawGraph(through points: [CGPoint]) {
        var path: UIBezierPath?

        switch type {
        case .curve:
            path = UIBezierPath(quadCurve: points)
        case .straight:
            path = UIBezierPath(straight: points)
        }

        line.color.setStroke()
        path?.lineWidth = line.width
        path?.stroke()
    }

    private func drawPoints(_ points: [CGPoint]) {
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
}

//MARK: - 속성 값을 변경하는 메서드
extension GesturableGraph {
    public func paddingOfTop(scale: Double) {
        guard scale >= .zero else { return }
        verticalPadding.top = scale
    }

    public func paddingOfBottom(scale: Double) {
        guard scale >= .zero else { return }
        verticalPadding.bottom = scale
    }
}

//MARK: - elements 값을 CGPoint로 변환시키는 메서드
extension GesturableGraph {
    private func convertToPoints() -> [CGPoint] {
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
        return bounds.width * (CGFloat(distribution.calibrationValue + 1) / 2 + CGFloat(index)) / CGFloat(elements.count + distribution.calibrationValue)
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

//MARK: - UIBezierPath 생성하는
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

    private func midPoint(from p1: CGPoint, to p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }

    private func controlPoint(p0: CGPoint, p2: CGPoint) -> CGPoint {
        var p1 = midPoint(from: p0, to: p2)
        p1.y = p0.y

        return p1
    }
}

//MARK: - verticalPadding 값에 따른 Top, Bottom 보정 값
private extension Array where Element == Double {
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
