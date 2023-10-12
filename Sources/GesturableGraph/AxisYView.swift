//
//  AxisYView.swift
//
//
//  Created by 박재우 on 10/10/23.
//

import UIKit

public class AxisYView: UIStackView {
    private let top: Double
    private let bottom: Double

    public var dataUnit: String = ""
    public var division: Int
    public var decimalPlaces: Int
    var data: [String] {
        return (0...division).map { index in
            let value = (top - ((top - bottom) * Double(index) / Double(division)))
            return formatDoubles(value)
        }
    }

    init(
        top: Double,
        bottom: Double,
        division: Int = Constraints.AxisYDivision,
        decimalPlaces: Int = 1
    ) {
        self.top = top
        self.bottom = bottom
        self.division = division
        self.decimalPlaces = decimalPlaces

        super.init(frame: .zero)

        axis = .vertical
        distribution = .equalSpacing
        setUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        removeAllArrangedSubviews()

        data.map { element in
            let textView = UITextView()
            textView.text = element + dataUnit
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            return textView
        }.forEach { textView in
            addArrangedSubview(textView)
        }
    }

    private func formatDoubles(_ element: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = decimalPlaces

        return formatter.string(from: NSNumber(value: element)) ?? ""
    }

    private func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
