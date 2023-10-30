//
//  GestureEnableView.swift
//
//
//  Created by 박재우 on 9/1/23.
//

import UIKit

class GestureEnableView: UIView {
    let lineView = UIView(frame: CGRect(x: 0, y: 0,
                                        width: Constraints.enableLineWidth,
                                        height: 0))
    let pointView = UIView(frame: CGRect(x: 0, y: 0,
                                         width: Constraints.enablePointWidth,
                                         height: Constraints.enablePointWidth))

    override var bounds: CGRect {
        didSet {
            lineView.frame.size.height = bounds.height
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

    private func setUI() {
        addSubview(lineView)
        addSubview(pointView)
    }

    private func setConfigure() {
        lineView.backgroundColor = Constraints.enableLineColor

        pointView.backgroundColor = Constraints.enablePointColor
        pointView.layer.cornerRadius = Constraints.enablePointWidth / 2
        pointView.clipsToBounds = true

        isHidden = true
    }

    func moveTo(_ point: CGPoint) {
        center.x = point.x
        lineView.center.x = bounds.width / 2
        pointView.center.x = bounds.width / 2
        pointView.center.y = point.y
    }

    func updatePointView(width: Double, color: UIColor) {
        pointView.frame.size.width = width
        pointView.frame.size.height = width
        pointView.layer.cornerRadius = width / 2
        pointView.backgroundColor = color

        setNeedsLayout()
    }

    func updateLineView(width: Double, color: UIColor) {
        lineView.frame.size.width = width
        lineView.backgroundColor = color

        setNeedsLayout()
    }
}
