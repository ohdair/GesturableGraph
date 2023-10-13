//
//  GesturableGraph.swift
//
//
//  Created by 박재우 on 10/11/23.
//

import UIKit

public final class GesturableGraph: UIView {
    private var graph: Graph

    public let gesturableGraphView: GesturableGraphView
    public let axisYView: AxisYView

    public lazy var elements = graph.elements {
        didSet {
            graph.elements = elements
        }
    }
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

    public init?(elements: [Double]) {
        guard let graph = Graph(elements: elements) else {
            return nil
        }

        self.graph = graph
        self.axisYView = AxisYView(top: graph.calibrationTop, bottom: graph.calibrationBottom)
        self.gesturableGraphView = GesturableGraphView(graph: graph)

        super.init(frame: .zero)

        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        addSubview(axisYView)
        addSubview(gesturableGraphView)

        axisYView.translatesAutoresizingMaskIntoConstraints = false
        gesturableGraphView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            axisYView.topAnchor.constraint(equalTo: topAnchor),
            axisYView.trailingAnchor.constraint(equalTo: trailingAnchor),
            axisYView.bottomAnchor.constraint(equalTo: bottomAnchor),

            gesturableGraphView.topAnchor.constraint(equalTo: axisYView.stackView.arrangedSubviews.first!.centerYAnchor),
            gesturableGraphView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gesturableGraphView.trailingAnchor.constraint(equalTo: axisYView.leadingAnchor),
            gesturableGraphView.bottomAnchor.constraint(equalTo: axisYView.stackView.arrangedSubviews.last!.centerYAnchor)
        ])
    }

}
