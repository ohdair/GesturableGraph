//
//  GestureEnableView.swift
//
//
//  Created by 박재우 on 9/1/23.
//

import UIKit

class GestureEnableView: UIView {
    private let lineView = UIView()
    private let pointView = UIView()

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
            lineView.widthAnchor.constraint(equalToConstant: GesturableGraphConstraint.enableLineWidth),
            lineView.centerXAnchor.constraint(equalTo: centerXAnchor),

            pointView.widthAnchor.constraint(equalToConstant: GesturableGraphConstraint.enablePointWidth),
            pointView.heightAnchor.constraint(equalToConstant: GesturableGraphConstraint.enablePointWidth),
            pointView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pointView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setConfigure() {
        lineView.backgroundColor = GesturableGraphConstraint.enableLineColor

        pointView.backgroundColor = GesturableGraphConstraint.enablePointColor
        pointView.layer.cornerRadius = GesturableGraphConstraint.enablePointWidth / 2
        pointView.clipsToBounds = true

        isHidden = true
    }

    func moveTo(x: CGFloat, y: CGFloat) {
        self.center.x = x
        pointView.center.y = y
    }
}
