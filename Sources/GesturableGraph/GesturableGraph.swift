//
//  GesturableGraph.swift
//
//
//  Created by 박재우 on 10/11/23.
//

import UIKit

public protocol GesturableGraphEnable: NSObject {
    func gesturableGraph(_ gesturableGraph: GesturableGraph, didTapWithData data: GraphData?)
}

public final class GesturableGraph: UIView, Gesturable {
    public weak var delegate: GesturableGraphEnable?

    public var graph: Graph {
        didSet {
            updateViews()
        }
    }
    public var axisXUnit: UnitOfTime = .hours {
        didSet {
            axisXView.time = axisXUnit
        }
    }
    public var axisY: AxisY = AxisY() {
        didSet {
            axisYView.dataUnit = axisY.dataUnit
            axisYView.division = axisY.division
            axisYView.decimalPlaces = axisY.decimalPlaces
            updateLayouts()
        }
    }
    public var extraUnits: [UIImage] = [] {
        didSet {
            extraUnitView.images = extraUnits
        }
    }

    public let gesturableGraphView: GesturableGraphView
    let axisXView: AxisXView
    let axisYView: AxisYView
    let extraUnitView: ExtraUnitView

    var gesture: CGPoint?

    private lazy var leftConstraints = [
        axisYView.leadingAnchor.constraint(equalTo: leadingAnchor),
        axisXView.leadingAnchor.constraint(equalTo: axisYView.trailingAnchor, constant: 5),
        axisXView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ]
    private lazy var rightConstraints = [
        axisYView.trailingAnchor.constraint(equalTo: trailingAnchor),
        axisXView.leadingAnchor.constraint(equalTo: leadingAnchor),
        axisXView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor, constant: -5),
    ]

    public init?(elements: [Double]) {
        guard let graph = Graph(elements: elements) else {
            return nil
        }

        self.graph = graph
        self.gesturableGraphView = GesturableGraphView(graph: graph)
        self.axisXView = AxisXView(axisXUnit, distribution: graph.calibrationDistribution)
        self.axisYView = AxisYView(axisY, top: graph.calibrationTop, bottom: graph.calibrationBottom)
        self.extraUnitView = ExtraUnitView(distribution: graph.calibrationDistribution)

        super.init(frame: .zero)

        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        addSubview(axisYView)
        addSubview(axisXView)
        addSubview(gesturableGraphView)
        addSubview(extraUnitView)

        axisYView.translatesAutoresizingMaskIntoConstraints = false
        axisXView.translatesAutoresizingMaskIntoConstraints = false
        gesturableGraphView.translatesAutoresizingMaskIntoConstraints = false
        extraUnitView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            axisYView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight + 3),
            axisYView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.gapHeight - 3),

            axisXView.bottomAnchor.constraint(equalTo: bottomAnchor),

            gesturableGraphView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight * 2 + 3),
            gesturableGraphView.centerXAnchor.constraint(equalTo: axisXView.centerXAnchor),
            gesturableGraphView.widthAnchor.constraint(equalTo: axisXView.widthAnchor),
            gesturableGraphView.bottomAnchor.constraint(equalTo: axisXView.topAnchor, constant: -3),

            extraUnitView.topAnchor.constraint(equalTo: topAnchor),
            extraUnitView.centerXAnchor.constraint(equalTo: axisXView.centerXAnchor),
            extraUnitView.widthAnchor.constraint(equalTo: axisXView.widthAnchor),
            extraUnitView.heightAnchor.constraint(equalToConstant: Constraints.gapHeight * 2)
        ])

        updateLayouts()
    }

    private func updateViews() {
        gesturableGraphView.graph = graph
        axisXView.distribution = graph.calibrationDistribution
        axisYView.top = graph.calibrationTop
        axisYView.bottom = graph.calibrationBottom
        extraUnitView.distribution = graph.calibrationDistribution
    }

    private func updateLayouts() {
        switch axisY.position {
        case .left:
            NSLayoutConstraint.deactivate(rightConstraints)
            NSLayoutConstraint.activate(leftConstraints)
        case .right:
            NSLayoutConstraint.deactivate(leftConstraints)
            NSLayoutConstraint.activate(rightConstraints)
        }
    }
}

// MARK: - Custom touch handling
extension GesturableGraph {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gesture = touches.first?.location(in: gesturableGraphView)

        if let point = calculatedPoint(in: graph, withSize: gesturableGraphView.bounds) {
            gesturableGraphView.gestureEnableView.moveTo(point)
            gesturableGraphView.gestureEnableView.isHidden = false

            let graphData = createGraphData(withPoint: point)
            delegate?.gesturableGraph(self, didTapWithData: graphData)
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gesturableGraphView.gestureEnableView.isHidden = true

        delegate?.gesturableGraph(self, didTapWithData: nil)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        gesture = touches.first?.location(in: gesturableGraphView)

        if let point = calculatedPoint(in: graph, withSize: gesturableGraphView.bounds) {
            gesturableGraphView.gestureEnableView.moveTo(point)

            let graphData = createGraphData(withPoint: point)
            delegate?.gesturableGraph(self, didTapWithData: graphData)
        }
    }

    private func createGraphData(withPoint point: CGPoint) -> GraphData {
        let axisXPosition = (point.x - (graph.calibrationDistribution * gesturableGraphView.bounds.width)) / (gesturableGraphView.bounds.width * (1 - graph.calibrationDistribution * 2))
        let axisXUnit = axisXUnit.timePointing(axisXPosition * Double(axisXUnit.unit))
        let axisYUnit = axisYView.top - (point.y / gesturableGraphView.bounds.height * (axisYView.top - axisYView.bottom))
        let formattedAxisYUnit = axisYUnit.formatDouble(decimalPlaces: axisY.decimalPlaces)

        var extraUnit: UIImage? = nil
        if !extraUnits.isEmpty {
            let index = Int((axisXPosition * Double(extraUnits.count - 1)).rounded())
            extraUnit = extraUnits[index]
        }

        return GraphData(
            axisX: axisXUnit,
            axisY: formattedAxisYUnit,
            extraUnit: extraUnit
        )
    }
}
