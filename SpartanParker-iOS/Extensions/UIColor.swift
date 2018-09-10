//
//  UIColor.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/20/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

extension UIColor {
    static var spartanBlue:      UIColor { return UIColor(hex: 0x579AD3) }
    static var spartanDarkGray:  UIColor { return UIColor(hex: 0x707070) }
    static var spartanLightGray: UIColor { return UIColor(hex: 0xEFEFEF) }
    static var spartanGray:      UIColor { return UIColor(hex: 0x6E6E6E) }
    static var spartanGreen:     UIColor { return UIColor(hex: 0x68D596) }
    static var spartanRed:       UIColor { return UIColor(hex: 0xF59292) }

    convenience init(hex: UInt) {
        let red:   CGFloat = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green: CGFloat = CGFloat((hex >>  8) & 0xFF) / 255.0
        let blue:  CGFloat = CGFloat((hex >>  0) & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
