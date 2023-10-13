//
//  AxisYView.swift
//
//
//  Created by 박재우 on 10/10/23.
//

import UIKit

public class AxisYView: UIView {
    private let top: Double
    private let bottom: Double
    private let stackView = UIStackView()

    public var dataUnit: String = "" {
        didSet {
            updateStackView()
        }
    }
    public var division: Int {
        didSet {
            updateStackView()
        }
    }
    public var decimalPlaces: Int {
        didSet {
            updateStackView()
        }
    }

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

        setStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing

        updateStackView()
    }

    private func updateStackView() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for element in data {
            let textView = UILabel()
            textView.text = element + dataUnit
            textView.backgroundColor = .clear

            stackView.addArrangedSubview(textView)
        }
    }

    private func formatDoubles(_ element: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = decimalPlaces

        return formatter.string(from: NSNumber(value: element)) ?? ""
    }
}
