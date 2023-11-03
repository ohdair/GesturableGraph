////
////  AxisXView.swift
////
////
////  Created by 박재우 on 9/13/23.
////

import UIKit

class AxisXView: UIView {
    private let stackView = UIStackView()
    private lazy var widthConstraint = stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 - (distribution * 2))
    var distribution: CGFloat {
        didSet {
            removeConstraint(widthConstraint)
            widthConstraint = stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 - (distribution * 2))
            widthConstraint.isActive = true
        }
    }
    var time: UnitOfTime {
        didSet {
            updateStackView()
        }
    }

    init(_ unit: UnitOfTime, distribution: CGFloat) {
        self.time = unit
        self.distribution = distribution

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
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            widthConstraint
        ])

        updateStackView()
    }

    private func updateStackView() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for date in time.data {
            let textView = UILabel()
            textView.text = dateFormatter(date: date)
            textView.font = .preferredFont(forTextStyle: .caption1)
            stackView.addArrangedSubview(textView)
        }
    }

    private func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        switch time {
        case .seconds:
            dateFormatter.dateFormat = "s초"
        case .minutes:
            dateFormatter.dateFormat = "m분"
        case .hours:
            dateFormatter.dateFormat = "a h시"
        case .days:
            dateFormatter.dateFormat = "d일"
        case .months:
            dateFormatter.dateFormat = "M월"
        }
        return dateFormatter.string(from: date)
    }
}
