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
        public var gradientColors: [UIColor] = Constraints.areaColors {
            didSet {
                if gradientColors.isEmpty {
                    gradientColors = oldValue
                }
            }
        }
        public var isFill: Bool = Constraints.areaIsFill
    }

    public struct GraphEnablePoint {
        public var width: Double = Constraints.enablePointWidth
        public var color: UIColor = Constraints.enablePointColor
    }

    public struct GraphEnableLine {
        public var width: Double = Constraints.enableLineWidth
        public var color: UIColor = Constraints.enableLineColor
    }
}
