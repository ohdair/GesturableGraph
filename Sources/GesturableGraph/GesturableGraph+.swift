extension GesturableGraph {

    // 0 means there is no separation
    // Increases in percentage based on the height of the graph.
    // The default value for top is 30 and bottom is 30.
    struct VerticalPadding {
        var top: Double = 0.3
        var bottom: Double = 0.3
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
}
