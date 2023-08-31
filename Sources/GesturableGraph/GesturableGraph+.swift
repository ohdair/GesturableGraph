import UIKit

extension GesturableGraph {
    // 0 means there is no separation
    // Increases in percentage based on the height of the graph.
    // The default value for top is 30 and bottom is 30.
    struct VerticalPadding {
        var top: Double
        var bottom: Double
    }

    public enum GraphType {
        case curve
        case straight
    }

    // equalSpacing is [o..o..o..o]
    // aroundSpacing is [.o..o..o..o.]
    // evenSpacing is [..o..o..o..o..]
    public enum Distribution: Int {
        case equalSpacing = -1
        case aroundSpacing
        case evenSpacing
    }

    public struct GraphLine {
        public var width: Double
        public var color: UIColor
    }

    public struct GraphPoint {
        public var width: Double
        public var color: UIColor
        public var isHidden: Bool
    }

    public struct GraphArea {
        var _colors: [UIColor] = []
        public var colors: [UIColor] {
            get {
                return _colors
            }
            set {
                if newValue.isEmpty {
                    return
                }
                _colors = newValue
            }
        }
        public var isFill: Bool
    }
}
