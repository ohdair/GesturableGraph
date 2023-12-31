//
//  Graph.swift
//
//
//  Created by 박재우 on 9/1/23.
//

import UIKit

public struct Graph {
    typealias Point = (x: Double, y: Double)

    private(set) var points: [Point]
    public var elements: [Double] {
        didSet {
            configurePoints()
        }
    }
    public var type: GraphType {
        didSet {
            configurePoints()
        }
    }
    public var distribution: Distribution {
        didSet {
            configurePoints()
        }
    }
    public var padding: Padding {
        didSet {
            configurePoints()
        }
    }
    var calibrationTop: Double {
        return elements.calibrationTop(ofValue: padding.top)!
    }
    var calibrationBottom: Double {
        return elements.calibrationBottom(ofValue: padding.bottom)!
    }
    var calibrationDistribution: Double {
        return (CGFloat(distribution.rawValue + 1) / 2) / CGFloat(elements.count + distribution.rawValue)
    }

    init?(elements: [Double],
          type: GraphType = .curve,
          distribution: Distribution = .equalSpacing,
          padding: Padding = Padding()) {
        guard elements.count > 1 else {
            return nil
        }

        self.points = []
        self.elements = elements
        self.type = type
        self.distribution = distribution
        self.padding = padding

        configurePoints()
    }

    init() {
        self.points = []
        self.elements = []
        self.type = .curve
        self.distribution = .equalSpacing
        self.padding = Padding()
    }

    private mutating func configurePoints() {
        points = elements.enumerated()
            .compactMap { index, _ in
                convertToPoint(ofIndex: index)
            }
    }

    private func convertToPoint(ofIndex index: Int) -> Point {
        let y = calculateY(ofElement: elements[index])
        let x = calculateX(ofIndex: index)

        return (x: x, y: y)
    }

    private func calculateX(ofIndex index: Int) -> Double {
        return (CGFloat(distribution.rawValue + 1) / 2 + CGFloat(index)) / CGFloat(elements.count + distribution.rawValue)
    }

    private func calculateY(ofElement element: Double) -> Double {
        return (calibrationTop - element) / (calibrationTop - calibrationBottom)
    }
}


extension Graph {
    // 0 means there is no separation
    // Increases in percentage based on the height of the graph.
    // The default value for top is 30 and bottom is 30.
    public struct Padding {
        public var top: Double = Constraints.topOfPadding {
            didSet {
                if top.isLess(than: 0) {
                    top = oldValue
                }
            }
        }
        public var bottom: Double = Constraints.bottomOfPadding {
            didSet {
                if bottom.isLess(than: 0) {
                    bottom = oldValue
                }
            }
        }
    }

    public enum GraphType {
        case curve
        case straight
    }

    // equalSpacing is [o..o..o..o]
    // aroundSpacing is [.o..o..o..o.]
    // evenSpacing is [..o..o..o..o..]
    public enum Distribution: Int {
        case equalSpacing = -1  // default
        case aroundSpacing
        case evenSpacing
    }
}
