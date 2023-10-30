//
//  ExtraUnitView.swift
//  
//
//  Created by 박재우 on 10/24/23.
//

import UIKit

class ExtraUnitView: UIView {
    private let stackView = UIStackView()
    var distribution: CGFloat {
        didSet {
            setNeedsDisplay()
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

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: bounds.width * distribution),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: bounds.width - (bounds.width * distribution * 2)),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        updateStackView()
    }

    func updateStackView() {
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
