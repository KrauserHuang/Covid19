//
//  ViewStyle.swift
//  CanadianCovid19
//
//  Created by Tai Chin Huang on 2021/9/26.
//

import UIKit

class ViewStyle: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 10
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.shadowOffset = .zero
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
