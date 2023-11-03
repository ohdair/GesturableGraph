//
//  ExtraUnitView.swift
//  
//
//  Created by 박재우 on 10/24/23.
//

import UIKit

class ExtraUnitView: UIView {
    private let stackView = UIStackView()
    private lazy var widthConstraint = stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 - (distribution * 2))
    var distribution: CGFloat {
        didSet {
            removeConstraint(widthConstraint)
            widthConstraint = stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 - (distribution * 2))
            widthConstraint.isActive = true
        }
    }
    var images: [UIImage] {
        didSet {
            guard !images.isEmpty else {
                isHidden = true
                return
            }
            isHidden = false
            updateStackView()
        }
    }

    init(images: [UIImage] = [], distribution: CGFloat) {
        self.images = images
        self.distribution = distribution

        super.init(frame: .zero)

        setStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

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

        for image in images {
            let imageView = UIImageView(image: image)
            imageView.sizeToFit()
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
    }
}
