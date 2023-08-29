import UIKit

@MainActor
public final class GesturableGraph: UIView {
    private(set) public var elements = [Double]()
    public var distribution = Distribution.equalSpacing
    public var type = GraphType.curve
    public var line = GraphLine(width: GesturableGraphConstraint.lineWidth,
                                color: GesturableGraphConstraint.lineColor)
    public var point = GraphPoint(width: GesturableGraphConstraint.pointWidth,
                                  color: GesturableGraphConstraint.pointColor,
                                  isHidden: GesturableGraphConstraint.pointIsHidden)
    public var area = GraphArea(colors: GesturableGraphConstraint.areaColors,
                                isFill: GesturableGraphConstraint.areaIsFill)
    var verticalPadding = VerticalPadding(top: GesturableGraphConstraint.topOfPadding,
                                                  bottom: GesturableGraphConstraint.bottomOfPadding)

    public init?(elements: [Double]) {
        guard elements.count > 1 else {
            return nil
        }

        super.init(frame: .zero)
        self.elements = elements
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let mainContext = UIGraphicsGetCurrentContext() else {
            return
        }

        mainContext.saveGState()

        guard let points = convertToPoints(elements),
              let graphPath = graphPath(through: points) else {
            return
        }

        fillGraphArea(graphPath, using: points)
        draw(graphPath)
        draw(points)
    }
}

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
