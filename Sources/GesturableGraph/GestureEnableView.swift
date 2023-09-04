//
//  GestureEnableView.swift
//
//
//  Created by 박재우 on 9/1/23.
//

import UIKit

class GestureEnableView: UIView {
    var lineView = UIView()
    var pointView = UIView()

    override var center: CGPoint {
        didSet {
//            lineView.center = CGPoint(x: center.x, y: 0)
            pointView.center = center
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        setConfigure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUI() {
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

    func setConfigure() {
        lineView.backgroundColor = GesturableGraphConstraint.enableLineColor

        pointView.backgroundColor = UIColor.red
        pointView.layer.cornerRadius = GesturableGraphConstraint.enablePointWidth / 2
        pointView.clipsToBounds = true

//        isHidden = true
    }
}
