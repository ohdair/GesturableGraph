import UIKit

public class GesturableGraph: UIView {
    private var verticalPadding: Separation
    let elements: [Double]
    var distribution: Distribution

    public init?(_ frame: CGRect = .zero, elements: [Double]) {
        guard elements.count > 1 else {
            return nil
        }

        self.elements = elements
        self.distribution = .equalSpacing
        self.verticalPadding = Separation()
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        UIColor.blue.setStroke()
        let points = convertToPoints()
        let curveLinePath = UIBezierPath(quadCurve: points)

        curveLinePath?.lineWidth = 2
        curveLinePath?.lineJoinStyle = .round
        curveLinePath?.lineCapStyle = .round
        curveLinePath?.stroke()

        points.forEach { point in
            let pointPath = UIBezierPath(ovalIn: CGRect(x: point.x - 2, y: point.y - 2, width: 4, height: 4))
            UIColor.gray.set()
            pointPath.fill()
        }
    }
}

//MARK: - 속성 값을 변경하는 메서드
extension GesturableGraph {
    func padding(top: Int) {
        guard top >= 0 else { return }
        verticalPadding.top = top
    }

    func padding(bottom: Int) {
        guard bottom >= 0 else { return }
        verticalPadding.bottom = bottom
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
        return bounds.width * CGFloat(index + (distribution.calibrationValue + 1) / 2) / CGFloat(elements.count + distribution.calibrationValue)
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
public extension UIBezierPath {
    convenience init?(quadCurve points: [CGPoint]) {
        guard points.count > 1 else {
            return nil
        }

        self.init()

        // 시작점 표시
        var p0 = points[0]
        move(to: p0)

        // 값이 2개라면 직선으로 표시
        guard points.count != 2 else {
            addLine(to: points[1])
            return
        }

        // 중간점을 잡고 2개의 곡선 만들기
        for i in 1..<points.count {
            let p2 = midPoint(from: p0, to: points[i])

            addQuadCurve(to: p2, controlPoint: controlPoint(p0: p0, p2: p2))
            addQuadCurve(to: points[i], controlPoint: controlPoint(p0: points[i], p2: p2))

            p0 = points[i]
        }
    }

    private func midPoint(from p1: CGPoint, to p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }

    // 상향곡선으로 그릴 때에는 p0에 목적지로 두어야 하고,
    // 하향곡선에서는 p2에 목적지를 두어야 한다
    private func controlPoint(p0: CGPoint, p2: CGPoint) -> CGPoint {
        var p1 = midPoint(from: p0, to: p2)
        p1.y = p0.y

        return p1
    }
}

//MARK: - verticalPadding 값에 따른 Top, Bottom 보정 값
private extension Array where Element == Double {
    func calibrationTop(ofValue top: Int) -> Double? {
        guard let max = self.max(),
              let min = self.min()
        else {
            return nil
        }

        return max + ((max - min) * Double(top) / 100)
    }

    func calibrationBottom(ofValue bottom: Int) -> Double? {
        guard let max = self.max(),
              let min = self.min()
        else {
            return nil
        }

        return min - ((max - min) * Double(bottom) / 100)
    }
}
