//
//  AuthenticationViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/8/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class AuthenticationViewController: ViewController {
    
    private enum AuthenticationForm: Int {
        case login
        case register
    }

    private var segmentedController: SegmentedController!
    
    private var loginForm:    UserForm = UserForm()
    private var registerForm: UserForm = UserForm()
    
    private var loginFormCenterXConstraint:    NSLayoutConstraint!
    private var loginFormBottomConstraint:     NSLayoutConstraint!
    private var registerFormBottomConstraint:  NSLayoutConstraint!
    
    private var currentForm: AuthenticationForm = AuthenticationForm.login
    
    private var userFormWidth: CGFloat { return view.frame.width }

}

// MARK: - UIViewController Overrides
extension AuthenticationViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        segmentedController = SegmentedController(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: SegmentedController.defaultHeight))
        segmentedController.delegate       = self
        segmentedController.titleColor     = .spartanGray
        segmentedController.highlightColor = .spartanBlue
        segmentedController.addBottomBorder(width: 0.5,
                                            color: .lightGray,
                                            opacity: 0.5)
        segmentedController.commaSeparatedTitles = "Login,Register"
        view.addSubview(segmentedController)
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedController.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        segmentedController.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        segmentedController.heightAnchor.constraint(equalToConstant: SegmentedController.defaultHeight).isActive = true
        
        createLoginForm()
        createRegisterForm()
    }
}

// MARK: - SegmentedControllerDelegate Implementation
extension AuthenticationViewController: SegmentedControllerDelegate {
    
    func segmentedController(_ segmentedController: SegmentedController, didSelectSegmentAtIndex index: Int) {
        
        guard currentForm.rawValue != index,
            let selectedForm = AuthenticationForm(rawValue: index) else { return }
        
        switch selectedForm {
        case .login:    loginFormCenterXConstraint.constant = 0.0
        case .register: loginFormCenterXConstraint.constant = -(userFormWidth)
        }
        currentForm = selectedForm
        UIView.animate(withDuration: 0.4) {
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Login & Register Form
extension AuthenticationViewController: UserFormDelegate {
    
    private func createLoginForm() {
        
        loginForm.userFormDelegate = self
        view.addSubview(loginForm)
        
        loginForm.translatesAutoresizingMaskIntoConstraints = false
        loginForm.topAnchor.constraint(equalTo: segmentedController.bottomAnchor).isActive = true
        loginForm.widthAnchor.constraint(equalToConstant: userFormWidth).isActive = true
        loginFormCenterXConstraint = loginForm.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        loginFormCenterXConstraint.isActive = true
        loginFormBottomConstraint = loginForm.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        loginFormBottomConstraint.isActive = true
        
        let emailField    = TextField(placeHolder: "Email",    key: "email")
        let passwordField = TextField(placeHolder: "Password", key: "password")
        passwordField.inputField.isSecureTextEntry = true
        
        loginForm.insertRow(textField: emailField)
        loginForm.insertRow(textField: passwordField)
    }
    
    private func createRegisterForm() {
        
        registerForm.userFormDelegate  = self
        registerForm.textFieldDelegate = self
        view.addSubview(registerForm)
        
        registerForm.translatesAutoresizingMaskIntoConstraints = false
        registerForm.topAnchor.constraint(equalTo: segmentedController.bottomAnchor).isActive = true
        registerForm.leftAnchor.constraint(equalTo: loginForm.rightAnchor).isActive = true
        registerForm.widthAnchor.constraint(equalToConstant: userFormWidth).isActive = true
        registerFormBottomConstraint = registerForm.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        registerFormBottomConstraint.isActive = true
        
        let firstNameField = TextField(placeHolder: "First",    key: "first_name")
        let lastNameField  = TextField(placeHolder: "Last",     key: "last_name")
        let emailField     = TextField(placeHolder: "Email",    key: "email")
        let passwordField  = TextField(placeHolder: "Password", key: "password")
        
        emailField.inputField.keyboardType = .emailAddress
        passwordField.inputField.isSecureTextEntry = true
        
        registerForm.insertRow(textFields: [firstNameField, lastNameField])
        registerForm.insertRow(textField: emailField)
        registerForm.insertRow(textField: passwordField)
    }
    
    func userFormDidSelectContinue(_ userForm: UserForm) {
        
        // guard let data = userForm.allInputs() else { return }
        
        switch userForm {
        case loginForm:    verifyLoginFields(userForm)
        case registerForm: verifyRegisterFields(userForm)
        default: return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func verifyLoginFields(_ form: UserForm) {
        let alertView = AlertView(style: .alert)
        alertView.title   = "Test"
        alertView.message = "description"
        alertView.onConfirm {
            self.dismissAlertView()
        }
        //presentAlertView(alertView)
    }
    
    func verifyRegisterFields(_ form: UserForm) {
        
    }
    
    func displayInvalidCredentialAlert() {
        
    }
    
    func displayEmptyFieldAlert() {
        
    }
}

extension AuthenticationViewController {
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch currentForm {
        case .login:    loginFormBottomConstraint.constant    = 0.0
        case .register: registerFormBottomConstraint.constant = -500.0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    override func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch currentForm {
        case .login:    loginFormBottomConstraint.constant    = 0.0
        case .register: registerFormBottomConstraint.constant = 0.0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        return true
    }
}
