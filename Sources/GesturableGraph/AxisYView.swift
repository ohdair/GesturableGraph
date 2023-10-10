//
//  AxisYView.swift
//
//
//  Created by 박재우 on 10/10/23.
//

import UIKit

class AxisYView: UIStackView {
    private let top: Double
    private let bottom: Double

    var division: Int

    init(top: Double, bottom: Double, division: Int = Constraints.AxisYDivision) {
        self.top = top
        self.bottom = bottom
        self.division = division

        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let topTextView = UITextView()
        let bottomTextView = UITextView()
        topTextView.text = top.description
        bottomTextView.text = bottom.description

        self.addSubview(topTextView)
        self.addSubview(bottomTextView)
    }
}
