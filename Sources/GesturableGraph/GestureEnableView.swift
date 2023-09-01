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
            lineView.center = CGPoint(x: center.x, y: 0)
            pointView.center = center
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUI() {
        addSubview(lineView)
        addSubview(pointView)
    }

    func setConfigure() {
        lineView.frame = CGRect(x: 0, y: 0,
                                width: GesturableGraphConstraint.enableLineWidth,
                                height: self.frame.height)
        lineView.backgroundColor = GesturableGraphConstraint.enableLineColor

        pointView.frame = CGRect(x: 0, y: 0,
                                 width: GesturableGraphConstraint.enablePointWidth,
                                 height: GesturableGraphConstraint.enablePointWidth)
        pointView.backgroundColor = UIColor.red
        pointView.layer.cornerRadius = GesturableGraphConstraint.enablePointWidth / 2
        pointView.clipsToBounds = true

//        isHidden = true
    }
}
