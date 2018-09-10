//
//  OptionButton.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/10/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class OptionButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    convenience init() {
        self.init(type: .system)
        commonInit()
    }

    private func commonInit() {
        backgroundColor           = .white
        tintColor                 = .black
        titleLabel?.font          = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel?.textColor     = .black
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 2
        layer.masksToBounds       = true
        layer.cornerRadius        = UIView.Theme.cornerRadius
    }
}
