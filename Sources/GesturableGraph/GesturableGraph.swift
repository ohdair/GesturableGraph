import UIKit

public final class GesturableGraph: UIView {
    private(set) public var elements = [Double]()

    public lazy var distribution = graph.distribution {
        didSet {
            graph.distribution = distribution
        }
    }
    public lazy var type = graph.type {
        didSet {
            graph.type = type
        }
    }
    public lazy var padding = graph.padding {
        didSet {
            graph.padding = padding
        }
    }
    private lazy var points = {
        graph.points.map { x, y in
            CGPoint(x: bounds.width * x, y: bounds.height * y)
        }
    }()

    public var line = GraphLine()
    public var point = GraphPoint()
    public var area = GraphArea()

    private var gestureEnableView = GestureEnableView()
    private var graph: Graph

    public init?(elements: [Double]) {
        guard let graph = Graph(elements: elements) else {
            return nil
        }

        self.graph = graph

        super.init(frame: .zero)

        setUI()
    }

    override init(frame: CGRect) {
        self.graph = Graph()

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
            gestureEnableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gestureEnableView.widthAnchor.constraint(equalToConstant: 10),
            gestureEnableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        Constraints.graphWidth = self.frame.size.width
        Constraints.graphHeight = self.frame.size.height
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let mainContext = UIGraphicsGetCurrentContext() else {
            return
        }

        mainContext.saveGState()

        guard let graphPath = graphPath(through: points) else {
            return
        }

        fillGraphArea(graphPath, using: points)
        draw(graphPath)
        draw(points)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedPoint = touchedPoint(touches),
              let y = pointY(from: touchedPoint.x)
        else {
            return
        }

        gestureEnableView.moveTo(x: touchedPoint.x, y: y)
        gestureEnableView.isHidden = false
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureEnableView.isHidden = true
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedPoint = touchedPoint(touches),
              let y = pointY(from: touchedPoint.x)
        else {
            return
        }

        gestureEnableView.moveTo(x: touchedPoint.x, y: y)
    }

    private func touchedPoint(_ touches: Set<UITouch>) -> CGPoint? {
        guard let touchedPoint = touches.first?.location(in: self),
              touchedPoint.x > points.first!.x,
              touchedPoint.x < points.last!.x
        else {
            return nil
        }

        return touchedPoint
    }

    private func pointY(from x: Double) -> Double? {
        switch type {
        case .curve:
            return UIBezierPath().pointYOfCurveGraph(from: x, points: points)
        case .straight:
            return UIBezierPath().pointYOfStraightGraph(from: x, points: points)
        }
    }
}
