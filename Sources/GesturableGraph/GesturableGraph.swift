import UIKit

@MainActor
public final class GesturableGraph: UIView {
    private(set) public var elements = [Double]()
    private var points = [CGPoint]()
    public var distribution = Distribution.equalSpacing
    public var type = GraphType.curve
    public var line = GraphLine(width: GesturableGraphConstraint.lineWidth,
                                color: GesturableGraphConstraint.lineColor)
    public var point = GraphPoint(width: GesturableGraphConstraint.pointWidth,
                                  color: GesturableGraphConstraint.pointColor,
                                  isHidden: GesturableGraphConstraint.pointIsHidden)
    public var area = GraphArea(_colors: GesturableGraphConstraint.areaColors,
                                isFill: GesturableGraphConstraint.areaIsFill)
    var verticalPadding = VerticalPadding(top: GesturableGraphConstraint.topOfPadding,
                                          bottom: GesturableGraphConstraint.bottomOfPadding)

    private var gestureEnableView = GestureEnableView()

    public init?(elements: [Double]) {
        guard elements.count > 1 else {
            return nil
        }

        super.init(frame: .zero)
        self.elements = elements

        setUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        addSubview(gestureEnableView)
        gestureEnableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gestureEnableView.topAnchor.constraint(equalTo: topAnchor),
            gestureEnableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        GesturableGraphConstraint.graphWidth = self.frame.size.width
        GesturableGraphConstraint.graphHeight = self.frame.size.height
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

        self.points = points
        fillGraphArea(graphPath, using: points)
        draw(graphPath)
        draw(points)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedPoint = touches.first?.location(in: self),
              points.count > 1,
              touchedPoint.x > points.first!.x,
              touchedPoint.x < points.last!.x
        else {
            return
        }
        let y = UIBezierPath().movingPointY(from: touchedPoint.x, points: points)
        gestureEnableView.center = CGPoint(x: touchedPoint.x, y: y)
        gestureEnableView.isHidden = false
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureEnableView.isHidden = true
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedPoint = touches.first?.location(in: self),
              points.count > 1,
              touchedPoint.x > points.first!.x,
              touchedPoint.x < points.last!.x
        else {
            return
        }
        let y = UIBezierPath().movingPointY(from: touchedPoint.x, points: points)
        gestureEnableView.center = CGPoint(x: touchedPoint.x, y: y)
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
