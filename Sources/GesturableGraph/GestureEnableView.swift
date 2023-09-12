//
//  GestureEnableView.swift
//
//
//  Created by 박재우 on 9/1/23.
//

import UIKit

class GestureEnableView: UIView {
    let lineView = UIView()
    let pointView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setConfigure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        addSubview(lineView)
        addSubview(pointView)

        lineView.translatesAutoresizingMaskIntoConstraints = false
        pointView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: Constraints.enableLineWidth),
            lineView.centerXAnchor.constraint(equalTo: centerXAnchor),

            pointView.widthAnchor.constraint(equalToConstant: Constraints.enablePointWidth),
            pointView.heightAnchor.constraint(equalToConstant: Constraints.enablePointWidth),
            pointView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pointView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setConfigure() {
        lineView.backgroundColor = Constraints.enableLineColor

        pointView.backgroundColor = Constraints.enablePointColor
        pointView.layer.cornerRadius = Constraints.enablePointWidth / 2
        pointView.clipsToBounds = true

        isHidden = true
    }

    func moveTo(_ point: CGPoint) {
        self.center.x = point.x
        pointView.center.y = point.y
    }

    func updatePointView(width: Double, color: UIColor) {
        pointView.widthAnchor.constraint(equalToConstant: width).isActive = true
        pointView.backgroundColor = color
        setNeedsLayout()
    }

    func updateLineView(width: Double, color: UIColor) {
        lineView.widthAnchor.constraint(equalToConstant: width).isActive = true
        lineView.backgroundColor = color
        setNeedsLayout()
    }
}
