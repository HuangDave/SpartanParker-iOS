//
//  AlertView.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    enum AlertStyle {
        case alert
        case confirmation
    }
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.font          = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor     = .black
        label.textAlignment = .center
        return label
    }()
    
    let messageLabel: UILabel = {
        var label = UILabel()
        label.font          = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor     = UIColor(hex: 0x626262)
        label.textAlignment = .center
        return label
    }()
    
    lazy var cancelButton: UIButton? = {
        guard alertStyle != .alert else { return nil }
        var button = UIButton()
        button.titleLabel?.font          = UIFont.boldSystemFont(ofSize: 16.0)
        button.titleLabel?.textColor     = UIColor.white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius        = UIView.Theme.cornerRadius
        button.layer.masksToBounds       = true
        button.backgroundColor           = UIColor(hex: 0xF59292)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(didSelectCancel), for: .touchUpInside)
        return button
    }()
    
    let confirmButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.font          = UIFont.boldSystemFont(ofSize: 16.0)
        button.titleLabel?.textColor     = .white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius        = UIView.Theme.cornerRadius
        button.layer.masksToBounds       = true
        button.backgroundColor           = UIColor(hex: 0x68D596)
        button.setTitle("Confirm", for: .normal)
        button.addTarget(self, action: #selector(didSelectConfirm), for: .touchUpInside)
        return button
    }()
    
    private(set) var alertStyle: AlertStyle = .alert
    
    var title: String? {
        get { return titleLabel.text  }
        set { titleLabel.text = newValue }
    }
    
    var message: String? {
        get { return messageLabel.text     }
        set { messageLabel.text = newValue }
    }
    
    /* TODO: may need
    var attributedMessage: NSAttributedString? {
        get { return messageLabel.attributedText     }
        set { messageLabel.attributedText = newValue }
    } */
    
    private var cancelHandler:  (() -> Void)?
    private var confirmHandler: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(style: AlertStyle) {
        super.init(frame: CGRect(x: 0, y: 0, width: 334.0, height: 334.0))
        alertStyle = style
        commonInit()
    }
    
    private func commonInit() {
        
        let buttonWidth:  CGFloat = 140.0
        let buttonHeight: CGFloat = 44.0
        
        layer.cornerRadius  = UIView.Theme.cornerRadius
        layer.masksToBounds = true
        clipsToBounds       = true
        backgroundColor     = .white
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints               = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive       = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive     = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive   = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints                       = false
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive             = true
        messageLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive           = true
        
        if (alertStyle == .alert) {
            
            addSubview(confirmButton)
            confirmButton.translatesAutoresizingMaskIntoConstraints = false
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor).isActive        = true
            confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                = true
            confirmButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive            = true
            confirmButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive          = true
            
        } else {
            let horizontalSpacing: CGFloat = 20.0
            let stackView = UIStackView(arrangedSubviews: [cancelButton!, confirmButton])
            stackView.axis         = .horizontal
            stackView.alignment    = .fill
            stackView.distribution = .fillEqually
            stackView.spacing      = horizontalSpacing
            addSubview(stackView)
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 0.0).isActive = true
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(horizontalSpacing)).isActive = true
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalSpacing).isActive = true
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -(horizontalSpacing)).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        }
    }
    
    func onCancel(_ cancel: @escaping (() -> Void)) {
        cancelHandler = cancel
    }
    
    func onConfirm(_ confirm: @escaping (() -> Void)) {
        confirmHandler = confirm
    }
    
    @objc func didSelectCancel() {
        guard alertStyle != .alert else { return }
        cancelHandler?()
    }
    
    @objc func didSelectConfirm() {
        confirmHandler?()
    }
}
