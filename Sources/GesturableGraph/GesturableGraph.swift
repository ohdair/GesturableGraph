//
//  GesturableGraph.swift
//
//
//  Created by 박재우 on 10/11/23.
//

import UIKit

public final class GesturableGraph: UIView, Gesturable {
    public var graph: Graph {
        didSet {
            updateViews()
        }
    }
    public var axisX: AxisX = AxisX() {
        didSet {
            axisXView.time = axisX.time
        }
    }
    public var axisY: AxisY = AxisY() {
        didSet {
            axisYView.dataUnit = axisY.dataUnit
            axisYView.division = axisY.division
            axisYView.decimalPlaces = axisY.decimalPlaces
        }
    }
    public var extraUnit: ExtraUnit = ExtraUnit() {
        didSet {
            extraUnitView.images = extraUnit.images
        }
    }

    public let gesturableGraphView: GesturableGraphView
    let axisYView: AxisYView
    let extraUnitView: ExtraUnitView
    let axisXView: AxisXView

    public weak var delegate: GesturableGraphEnable?
    var gesture: CGPoint?

    public init?(elements: [Double]) {
        guard let graph = Graph(elements: elements) else {
            return nil
        }

        self.graph = graph
        self.gesturableGraphView = GesturableGraphView(graph: graph)
        self.axisXView = AxisXView(axisX, distribution: graph.calibrationDistribution)
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
                axisYView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight),
                axisYView.leadingAnchor.constraint(equalTo: leadingAnchor),
                axisYView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.gapHeight),

                axisXView.bottomAnchor.constraint(equalTo: bottomAnchor),
                axisXView.leadingAnchor.constraint(equalTo: axisYView.trailingAnchor),
                axisXView.trailingAnchor.constraint(equalTo: trailingAnchor),

                gesturableGraphView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight * 2),
                gesturableGraphView.leadingAnchor.constraint(equalTo: axisYView.trailingAnchor),
                gesturableGraphView.trailingAnchor.constraint(equalTo: trailingAnchor),
                gesturableGraphView.bottomAnchor.constraint(equalTo: axisXView.topAnchor),

                extraUnitView.topAnchor.constraint(equalTo: topAnchor),
                extraUnitView.leadingAnchor.constraint(equalTo: axisYView.trailingAnchor),
                extraUnitView.trailingAnchor.constraint(equalTo: trailingAnchor),
                extraUnitView.heightAnchor.constraint(equalToConstant: Constraints.gapHeight * 2)
            ])
        case .right:
            NSLayoutConstraint.activate([
                axisYView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight),
                axisYView.trailingAnchor.constraint(equalTo: trailingAnchor),
                axisYView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.gapHeight),

                axisXView.bottomAnchor.constraint(equalTo: bottomAnchor),
                axisXView.leadingAnchor.constraint(equalTo: leadingAnchor),
                axisXView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor),

                gesturableGraphView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gapHeight * 2),
                gesturableGraphView.leadingAnchor.constraint(equalTo: leadingAnchor),
                gesturableGraphView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor),
                gesturableGraphView.bottomAnchor.constraint(equalTo: axisXView.topAnchor),

                extraUnitView.topAnchor.constraint(equalTo: topAnchor),
                extraUnitView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor),
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

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gesture = touches.first?.location(in: gesturableGraphView)

        if let point = calculatedPoint(in: graph, withSize: gesturableGraphView.bounds) {
            gesturableGraphView.gestureEnableView.moveTo(point)
            gesturableGraphView.gestureEnableView.isHidden = false

            let value = axisYView.top - (point.y / gesturableGraphView.bounds.height * (axisYView.top - axisYView.bottom))
            delegate?.gesturableGraph(self, didTapWithData: GraphData(axisX: "", axisY: axisYView.formatDoubles(value)))
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gesturableGraphView.gestureEnableView.isHidden = true
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        gesture = touches.first?.location(in: gesturableGraphView)

        if let point = calculatedPoint(in: graph, withSize: gesturableGraphView.bounds) {
            gesturableGraphView.gestureEnableView.moveTo(point)

            let d = (point.x / gesturableGraphView.bounds.width) * Double(axisX.time.unit)
            let x = axisX.time.timePointing(d)

            let value = axisYView.top - (point.y / gesturableGraphView.bounds.height * (axisYView.top - axisYView.bottom))
            
            var extra: UIImage? = nil
            if !extraUnit.images.isEmpty {
                let extraIndex = Int(((point.x / gesturableGraphView.bounds.width) * Double(extraUnit.images.count-1)).rounded())
                extra = extraUnit.images[extraIndex]
            }

            delegate?.gesturableGraph(self, didTapWithData: GraphData(axisX: x, axisY: axisYView.formatDoubles(value), extraUnit: extra))
        }
    }
}

public protocol GesturableGraphEnable: NSObject {
    func gesturableGraph(_ gesturableGraph: GesturableGraph, didTapWithData data: GraphData)
}
