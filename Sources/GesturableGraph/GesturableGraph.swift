import UIKit

public class GesturableGraph: UIView {
    private var verticalPadding: Separation
    let elements: [Double]
    var distribution: Distribution

    public init(_ frame: CGRect = .zero, elements: [Double]) {
        self.elements = elements
        self.distribution = .equalSpacing
        self.verticalPadding = Separation()
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GesturableGraph {
    func padding(top: Int) {
        guard top >= 0 else { return }
        verticalPadding.top = top
    }

    func padding(bottom: Int) {
        guard bottom >= 0 else { return }
        verticalPadding.bottom = bottom
    }
}
