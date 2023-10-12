import UIKit

public class GesturableGraphView: UIView, Gesturable {
    private var elements = [Double]()

    private lazy var points = {
        graph.points.map { x, y in
            CGPoint(x: bounds.width * x, y: bounds.height * y)
        }
    }()

    public var line = GraphLine()
    public var point = GraphPoint()
    public var area = GraphArea()
    public var enablePoint = GraphEnablePoint() {
        didSet {
            gestureEnableView.updatePointView(width: enablePoint.width,
                                              color: enablePoint.color)
        }
    }
    public var enableLine = GraphEnableLine() {
        didSet {
            gestureEnableView.updateLineView(width: enableLine.width,
                                              color: enableLine.color)
        }
    }

    var gesture: CGPoint?

    private var gestureEnableView = GestureEnableView()
    var graph: Graph

    public init(graph: Graph) {
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
        let enableViewidth = max(enableLine.width, enablePoint.width)
        addSubview(gestureEnableView)
        gestureEnableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gestureEnableView.topAnchor.constraint(equalTo: topAnchor),
            gestureEnableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gestureEnableView.widthAnchor.constraint(equalToConstant: enableViewidth),
            gestureEnableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
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
        gesture = touches.first?.location(in: self)

        if let point = calculatedPoint(in: graph, withSize: bounds) {
            gestureEnableView.moveTo(point)
            gestureEnableView.isHidden = false
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureEnableView.isHidden = true
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        gesture = touches.first?.location(in: self)

        if let point = calculatedPoint(in: graph, withSize: bounds) {
            gestureEnableView.moveTo(point)
        }
    }
}
