////
////  AxisXView.swift
////
////
////  Created by 박재우 on 9/13/23.
////

import UIKit

class AxisXView: UIView {
    private let stackView = UIStackView()
    var time: AxisX.UnitOfTime {
        didSet {
            updateStackView()
        }
    }

    init(_ axisX: AxisX) {
        self.time = axisX.time

        super.init(frame: .zero)

        setStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

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

    func updateStackView() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for date in time.data {
            let textView = UILabel()
            textView.text = time.dateFormatter(date: date)
            textView.font = .preferredFont(forTextStyle: .caption1)
            stackView.addArrangedSubview(textView)
        }
    }
}
