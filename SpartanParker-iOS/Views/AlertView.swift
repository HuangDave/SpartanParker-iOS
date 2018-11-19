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

    let titleLabel: UILabel = create(UILabel()) {
        $0.font          = UIFont.boldSystemFont(ofSize: 24.0)
        $0.textColor     = .black
        $0.textAlignment = .center
    }

    let messageLabel: UILabel = create(UILabel()) {
        $0.font          = UIFont.boldSystemFont(ofSize: 20.0)
        $0.textColor     = .spartanDarkGray
        $0.textAlignment = .center
        $0.numberOfLines = 5
    }

    lazy var cancelButton: UIButton? = {
        guard alertStyle != .alert else { return nil }
        return create(UIButton()) {
            $0.titleLabel?.font          = UIFont.boldSystemFont(ofSize: 14.0)
            $0.titleLabel?.textColor     = UIColor.white
            $0.titleLabel?.textAlignment = .center
            $0.layer.cornerRadius        = 20.0
            $0.layer.masksToBounds       = true
            $0.backgroundColor           = .spartanRed
            $0.setTitle("CANCEL", for: .normal)
            $0.addTarget(self, action: #selector(didSelectCancel), for: .touchUpInside)
        }
    }()

    let confirmButton: UIButton = create(UIButton()) {
        $0.titleLabel?.font          = UIFont.boldSystemFont(ofSize: 14.0)
        $0.titleLabel?.textColor     = .white
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius        = 20.0
        $0.layer.masksToBounds       = true
        $0.backgroundColor           = .spartanGreen
        $0.setTitle("CONFIRM", for: .normal)
        $0.addTarget(self, action: #selector(didSelectConfirm), for: .touchUpInside)
    }

    private(set) var alertStyle: AlertStyle = .alert

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
        layer.cornerRadius  = UIView.Theme.cornerRadius
        layer.masksToBounds = true
        clipsToBounds       = true
        backgroundColor     = .white
        setupLabels()
        setupContinueButton()
    }

    private func setupLabels() {
        let titleLabelHeight: CGFloat = 50.0
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: 10.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight).isActive = true
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    private func setupContinueButton() {
        let buttonWidth:  CGFloat = 140.0
        let buttonHeight: CGFloat = 44.0

        if (alertStyle == .alert) {
            let confirmButtonBottomOffset: CGFloat = -10.0
            addSubview(confirmButton)
            confirmButton.translatesAutoresizingMaskIntoConstraints = false
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor).isActive = true
            confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: confirmButtonBottomOffset).isActive = true
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            confirmButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            confirmButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        } else {
            let horizontalSpacing: CGFloat = 20.0
            let stackView = UIStackView(arrangedSubviews: [cancelButton!, confirmButton])
            stackView.axis         = .horizontal
            stackView.alignment    = .fill
            stackView.distribution = .fillEqually
            stackView.spacing      = horizontalSpacing
            addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -(horizontalSpacing)).isActive = true
            stackView.leftAnchor.constraint(equalTo: leftAnchor,
                                            constant: horizontalSpacing).isActive = true
            stackView.rightAnchor.constraint(equalTo: rightAnchor,
                                             constant: -(horizontalSpacing)).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        }
    }

    // MARK: Handlers

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

// MARK: - Accessors
extension AlertView {
    var title: String? {
        get { return titleLabel.text  }
        set { titleLabel.text = newValue }
    }
    var message: String? {
        get { return messageLabel.text     }
        set { messageLabel.text = newValue }
    }
}
