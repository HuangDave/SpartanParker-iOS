//
//  TextField.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/21/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class TextField: UIControl {
    
    weak var delegate: UITextFieldDelegate? {
        get { return inputField.delegate     }
        set { inputField.delegate = newValue }
    }
    
    static let defaultHeight: CGFloat = 44.0
    
    private(set) var key: String!
    
    let inputField: UITextField! = {
        let field = UITextField()
        field.borderStyle     = .none
        field.textColor       = .black
        field.font            = UIFont.descriptionFont
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    var placeHolderText: String? {
        get { return inputField.placeholder }
        set {
            if let text = newValue {
                inputField.attributedPlaceholder = NSAttributedString(string: text,
                                                                      attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }
        }
    }
    
    var text: String? { return inputField.text }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(placeHolder: String, key: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 375, height: TextField.defaultHeight))
        commonInit()
        placeHolderText = placeHolder
        self.key = key
    }
    
    func commonInit() {
        
        backgroundColor     = .white
        clipsToBounds       = true
        layer.masksToBounds = true
        layer.cornerRadius  = UIView.Theme.cornerRadius
    
        addSubview(inputField)
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.topAnchor.constraint(equalTo: topAnchor,       constant:  0).isActive = true
        inputField.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  0).isActive = true
        inputField.leftAnchor.constraint(equalTo: leftAnchor,     constant:  32.0).isActive = true
        inputField.rightAnchor.constraint(equalTo: rightAnchor,   constant: -10.0).isActive = true
    }
}
