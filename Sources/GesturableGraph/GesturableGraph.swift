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

    private var movingLine: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if let height = GesturableGraphConstraint.graphHeight {
            view.frame = CGRect(x: 0, y: 0, width: 8, height: height)
        }
        return view
    }()

    private var movingPoint: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        view.layer.cornerRadius = view.layer.bounds.width / 2
        view.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        view.layer.borderWidth = 1.5
        view.clipsToBounds = true
        return view
    }()

    public init?(elements: [Double]) {
        guard elements.count > 1 else {
            return nil
        }

        super.init(frame: .zero)
        self.elements = elements

        addSubview(movingLine)
        addSubview(movingPoint)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(movingLine)
        addSubview(movingPoint)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        guard let touchedPoint = touches.first?.location(in: self) else { return }

        movingLine.isHidden = false
        movingLine.frame.origin.x = touchedPoint.x

        movingPoint.isHidden = false
        let circleY = UIBezierPath().movingPointY(from: touchedPoint.x, points: points)
        movingPoint.center = CGPoint(x: touchedPoint.x, y: circleY)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingLine.isHidden = true
        movingPoint.isHidden = true
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedPoint = touches.first?.location(in: self) else { return }

        if touchedPoint.x >= 0, touchedPoint.x <= bounds.maxX {
            movingLine.center = CGPoint(x: touchedPoint.x, y: movingLine.center.y)
            let circleY = UIBezierPath().movingPointY(from: touchedPoint.x, points: points)
            movingPoint.center = CGPoint(x: touchedPoint.x, y: circleY)
        }
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
