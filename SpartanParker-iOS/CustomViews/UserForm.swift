//
//  UserForm.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/21/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

protocol UserFormDelegate: class {
    
    func userFormDidSelectContinue(_ userForm: UserForm)
}

class UserForm: UIScrollView {
    
    static let defaultRowHeight:  CGFloat = 44.0
    static let horizontalPadding: CGFloat = 25.0
    static let verticalSpacing:   CGFloat = 32.0
    
    weak var userFormDelegate:  UserFormDelegate?
    
    weak var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            inputFields.forEach { field in
                field.delegate = textFieldDelegate
            }
        }
    }
    
    private(set) var inputFields: [TextField] = []
    
    private var previousRow: UIView?
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .spartanBlue
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font    = UIFont.boldSystemFont(ofSize: 16)
        button.layer.masksToBounds = true
        button.layer.cornerRadius  = 14.0
        button.addTarget(self, action: #selector(userDidSelectContinue), for: .touchUpInside)
        return button
    }()
    
    private var continueButtonTopConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
        backgroundColor        = .spartanLightGray
        isScrollEnabled        = true
        bounces                = true
        alwaysBounceHorizontal = false
        alwaysBounceVertical   = true
        
        addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        continueButton.leftAnchor.constraint(equalTo: leftAnchor, constant: UserForm.horizontalPadding).isActive = true
        continueButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -(UserForm.horizontalPadding)).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: UserForm.defaultRowHeight).isActive = true
        continueButtonTopConstraint = continueButton.topAnchor.constraint(equalTo: topAnchor, constant: UserForm.verticalSpacing)
        continueButtonTopConstraint.isActive = true
    }
    
    private func insertRow(view: UIView) {
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if previousRow != nil {
            view.topAnchor.constraint(equalTo: previousRow!.bottomAnchor, constant: UserForm.verticalSpacing).isActive = true
        } else {
            view.topAnchor.constraint(equalTo: topAnchor, constant: UserForm.verticalSpacing * 2.0).isActive = true
        }
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor, constant:  UserForm.horizontalPadding).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: -UserForm.horizontalPadding).isActive = true
        view.heightAnchor.constraint(equalToConstant: UserForm.defaultRowHeight).isActive = true
        
        previousRow = view
        repositionContinueButton()
        
        let newContentHeight = (UserForm.verticalSpacing + UserForm.defaultRowHeight) * CGFloat(inputFields.count)
        contentSize = CGSize(width: contentSize.width, height: newContentHeight)
    }
    
    func insertRow(textField: TextField) {
        
        insertRow(view: textField)
        inputFields.append(textField)
        textField.delegate = textFieldDelegate
    }
    
    func insertRow(textFields: [TextField]) {
        
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.axis         = .horizontal
        stackView.alignment    = .fill
        stackView.distribution = .fillEqually
        stackView.spacing      = 20.0
        insertRow(view: stackView)
        
        textFields.forEach { field in
            inputFields.append(field)
        }
    }
    
    func invalidateView() {
        
        for field in inputFields {
            field.removeFromSuperview()
        }
        inputFields.removeAll()
        previousRow = nil
        repositionContinueButton()
    }
    
    func repositionContinueButton() {
        
        continueButtonTopConstraint.isActive = false
        continueButton.removeConstraint(continueButtonTopConstraint)
        if let row = previousRow {
            continueButtonTopConstraint = continueButton.topAnchor.constraint(equalTo: row.bottomAnchor, constant: UserForm.verticalSpacing * 2.0)
        } else {
            continueButtonTopConstraint = continueButton.topAnchor.constraint(equalTo: topAnchor, constant: UserForm.verticalSpacing)
        }
        continueButtonTopConstraint.isActive = true
    }
    
    func allInputs() -> [String: String?]? {
        
        guard inputFields.count > 0 else { return nil }
        
        var inputs: [String: String?] = [:]
        inputFields.forEach { field in
            inputs[field.key] = field.text
        }
        return inputs
    }
    
    @objc func userDidSelectContinue() {
        
        continueButton.isEnabled = false
        defer { continueButton.isEnabled = true }
        userFormDelegate?.userFormDidSelectContinue(self)
    }
}
