//
//  UIView.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/20/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

extension UIView {
    
    func addTopBorder(width: CGFloat, color: UIColor, opacity: Float = 1.0) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.opacity = opacity
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }
    
    func addBottomBorder(width: CGFloat, color: UIColor, opacity: Float = 1.0) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.opacity = opacity
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }
    
}
