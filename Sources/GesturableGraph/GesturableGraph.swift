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
