//
//  AxisYView.swift
//
//
//  Created by 박재우 on 10/10/23.
//

import UIKit

class AxisYView: UIView {
    private let stackView = UIStackView()
    var top: Double
    var bottom: Double

    var dataUnit: String {
        didSet {
            updateLabels()
        }
    }
    var division: Int {
        didSet {
            updateStackView()
        }
    }
    var decimalPlaces: Int {
        didSet {
            updateLabels()
        }
    }

    private var data: [String] {
        return (0...division).map { index in
            let value = (top - ((top - bottom) * Double(index) / Double(division)))
            return value.formatDouble(decimalPlaces: decimalPlaces)
        }
    }

    init(
        _ axisY: AxisY,
        top: Double,
        bottom: Double
    ) {
        self.top = top
        self.bottom = bottom
        self.dataUnit = axisY.dataUnit
        self.division = axisY.division
        self.decimalPlaces = axisY.decimalPlaces

        super.init(frame: .zero)

        setStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        updateStackView()
    }

    private func updateStackView() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for element in data {
            let textView = UILabel()
            textView.text = element + dataUnit
            textView.font = .preferredFont(forTextStyle: .caption1)
            stackView.addArrangedSubview(textView)
        }
    }

    private func updateLabels() {
        zip(stackView.arrangedSubviews, data).forEach { view, value in
            (view as! UILabel).text = value + dataUnit
        }
    }
}
