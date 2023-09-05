import UIKit

extension GesturableGraph {
    public struct GraphLine {
        public var width: Double = Constraints.lineWidth
        public var color: UIColor = Constraints.lineColor
    }

    public struct GraphPoint {
        public var width: Double = Constraints.pointWidth
        public var color: UIColor = Constraints.pointColor
        public var isHidden: Bool = Constraints.pointIsHidden
    }

    public struct GraphArea {
        public var colors: [UIColor] = Constraints.areaColors {
            didSet {
                if colors.isEmpty {
                    colors = oldValue
                }
            }
        }
        public var isFill: Bool = Constraints.areaIsFill
    }
}
