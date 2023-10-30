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

    override public func layoutSubviews() {
        super.layoutSubviews()

        switch axisY.position {
        case .left:
            NSLayoutConstraint.activate([
                axisYView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight + 3),
                axisYView.leadingAnchor.constraint(equalTo: leadingAnchor),
                axisYView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.gapHeight - 3),

                axisXView.bottomAnchor.constraint(equalTo: bottomAnchor),
                axisXView.leadingAnchor.constraint(equalTo: axisYView.trailingAnchor, constant: 5),
                axisXView.trailingAnchor.constraint(equalTo: trailingAnchor),

                gesturableGraphView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight * 2 + 3),
                gesturableGraphView.leadingAnchor.constraint(equalTo: axisYView.trailingAnchor, constant: 5),
                gesturableGraphView.trailingAnchor.constraint(equalTo: trailingAnchor),
                gesturableGraphView.bottomAnchor.constraint(equalTo: axisXView.topAnchor, constant: -3),

                extraUnitView.topAnchor.constraint(equalTo: topAnchor),
                extraUnitView.leadingAnchor.constraint(equalTo: axisYView.trailingAnchor, constant: 5),
                extraUnitView.trailingAnchor.constraint(equalTo: trailingAnchor),
                extraUnitView.heightAnchor.constraint(equalToConstant: Constraints.gapHeight * 2)
            ])
        case .right:
            NSLayoutConstraint.activate([
                axisYView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight + 3),
                axisYView.trailingAnchor.constraint(equalTo: trailingAnchor),
                axisYView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.gapHeight - 3),

                axisXView.bottomAnchor.constraint(equalTo: bottomAnchor),
                axisXView.leadingAnchor.constraint(equalTo: leadingAnchor),
                axisXView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor, constant: -5),

                gesturableGraphView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight * 2 + 3),
                gesturableGraphView.leadingAnchor.constraint(equalTo: leadingAnchor),
                gesturableGraphView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor, constant: -5),
                gesturableGraphView.bottomAnchor.constraint(equalTo: axisXView.topAnchor, constant: -3),

                extraUnitView.topAnchor.constraint(equalTo: topAnchor),
                extraUnitView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor, constant: -5),
                extraUnitView.leadingAnchor.constraint(equalTo: leadingAnchor),
                extraUnitView.heightAnchor.constraint(equalToConstant: Constraints.gapHeight * 2)
            ])
        }
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
    }

    private func updateViews() {
        gesturableGraphView.graph = graph
        axisXView.distribution = graph.calibrationDistribution
        axisYView.top = graph.calibrationTop
        axisYView.bottom = graph.calibrationBottom
        extraUnitView.distribution = graph.calibrationDistribution
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

        var extraUnit: UIImage? = nil
        if !extraUnits.isEmpty {
            let index = Int((axisXPosition * Double(extraUnits.count - 1)).rounded())
            extraUnit = extraUnits[index]
        }

        return GraphData(axisX: axisXUnit, axisY: axisYView.formatDoubles(axisYUnit), extraUnit: extraUnit)
    }
}
