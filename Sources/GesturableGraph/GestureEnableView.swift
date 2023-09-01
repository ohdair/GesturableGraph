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
            lineView.center = center
            pointView.center = center
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUI() {
        addSubview(lineView)
        addSubview(pointView)

        lineView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setConfigure() {
        lineView.frame = CGRect(x: 0, y: 0,
                                width: GesturableGraphConstraint.enableLineWidth,
                                height: 0)
        lineView.backgroundColor = GesturableGraphConstraint.enableLineColor

        pointView.frame = CGRect(x: 0, y: 0,
                                 width: GesturableGraphConstraint.enablePointWidth,
                                 height: GesturableGraphConstraint.enablePointWidth)
        pointView.backgroundColor = GesturableGraphConstraint.enablePointColor
        pointView.layer.cornerRadius = GesturableGraphConstraint.enablePointWidth / 2
        pointView.clipsToBounds = true

        isHidden = true
    }
}
