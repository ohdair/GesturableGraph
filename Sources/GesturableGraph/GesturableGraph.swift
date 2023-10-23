//
//  GesturableGraph.swift
//
//
//  Created by 박재우 on 10/11/23.
//

import UIKit

public final class GesturableGraph: UIView {
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

    public let gesturableGraphView: GesturableGraphView
    let axisXView: AxisXView
    let axisYView: AxisYView

    public init?(elements: [Double]) {
        guard let graph = Graph(elements: elements) else {
            return nil
        }

        self.graph = graph
        self.gesturableGraphView = GesturableGraphView(graph: graph)
        self.axisXView = AxisXView(axisX)
        self.axisYView = AxisYView(axisY, top: graph.calibrationTop, bottom: graph.calibrationBottom)

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

        axisYView.translatesAutoresizingMaskIntoConstraints = false
        axisXView.translatesAutoresizingMaskIntoConstraints = false
        gesturableGraphView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            axisYView.topAnchor.constraint(equalTo: topAnchor),
            axisYView.trailingAnchor.constraint(equalTo: trailingAnchor),
            axisYView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIFont.preferredFont(forTextStyle: .caption1).lineHeight / 2),

            axisXView.bottomAnchor.constraint(equalTo: bottomAnchor),
            axisXView.leadingAnchor.constraint(equalTo: leadingAnchor),
            axisXView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor),

            gesturableGraphView.topAnchor.constraint(equalTo: topAnchor, constant: UIFont.preferredFont(forTextStyle: .caption1).lineHeight / 2),
            gesturableGraphView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gesturableGraphView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor),
            gesturableGraphView.bottomAnchor.constraint(equalTo: axisXView.topAnchor)
        ])
    }
    
    private func updateViews() {
        gesturableGraphView.graph = graph
        axisYView.top = graph.calibrationTop
        axisYView.bottom = graph.calibrationBottom
    }
}
