//
//  AuthenticationViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/8/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

import AWSCognitoAuth
import AWSCognitoIdentityProvider

class AuthenticationViewController: ViewController {
    private enum AuthenticationForm: Int {
        case login    = 0
        case register = 1
    }

    private var segmentedController: SegmentedController!
    private var loginForm: LoginForm = LoginForm()
    private var registerForm: RegisterForm = RegisterForm()
    private var loginFormCenterXConstraint:    NSLayoutConstraint!
    private var loginFormBottomConstraint:     NSLayoutConstraint!
    private var registerFormBottomConstraint:  NSLayoutConstraint!
    private var currentForm: AuthenticationForm = AuthenticationForm.login
    private var userFormWidth: CGFloat { return view.frame.width }

    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?

    // MARK: - UIViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        // disable swipe for popping back navigation stack and add done button to navigation bar
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(didSelectDone))
        view.backgroundColor = UIColor.spartanLightGray
        setupSegmentedController()
        setupLoginForm()
        setupRegisterForm()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: User Interaction
    @objc private func didSelectDone(button: UIBarButtonItem) {
        button.isEnabled = false
        view.endEditing(true)

        #if DEBUG // REMOVEME:
        loginForm.emailField.inputField.text    = "huangd95@gmail.com"
        loginForm.passwordField.inputField.text = "test1234"

        registerForm.sjsuIdField.inputField.text       = "009238996"
        registerForm.firstNameField.inputField.text    = "David"
        registerForm.lastNameField.inputField.text     = "Huang"
        registerForm.emailField.inputField.text        = "huangd95@gmail.com"
        registerForm.passwordField.inputField.text     = "test1234"
        registerForm.licensePlateField.inputField.text = "abc1234"
        #endif

        let userForm = currentForm == .login ? loginForm : registerForm
        // attempt to get input information and present an alert if any field was empty or invalid
        var formAttributes: [String: AWSCognitoIdentityUserAttributeType] = [:]
        var errorDescription: String?
        do {
            formAttributes = try userForm.getAllInputs()
        } catch TextField.InputError.emtpy(let description) {
            errorDescription = description
        } catch TextField.InputError.invalid(let description) {
            errorDescription = description
        } catch _ { return }

        if let message = errorDescription {
            presentErrorAlert(message: message, buttonTitle: "Back")
            return
        }

        switch userForm {
        case loginForm:
            loginUser(email: formAttributes["email"]!.value!, password: formAttributes["password"]!.value!)
        case registerForm:
            registerUser(attributes: formAttributes)
        default: return
        }
    }
}

// MARK: - SegmentedControllerDelegate Implementation
extension AuthenticationViewController: SegmentedControllerDelegate {
    /// Initialize and set constraints for segmented controller to switch between
    /// the login and register forms
    private func setupSegmentedController() {
        segmentedController = SegmentedController(frame: CGRect(x: 0, y: 0,
                                                                width: view.frame.width,
                                                                height: SegmentedController.defaultHeight))
        segmentedController.delegate       = self
        segmentedController.titleColor     = .spartanGray
        segmentedController.highlightColor = .spartanBlue
        segmentedController.titles         = ["Login", "Register"]
        segmentedController.addBottomBorder(width: 0.5, color: .lightGray, opacity: 0.5)
        view.addSubview(segmentedController)
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedController.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        segmentedController.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        segmentedController.heightAnchor.constraint(equalToConstant: SegmentedController.defaultHeight).isActive = true
    }

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

// MARK: Login Form
extension AuthenticationViewController {
    private func setupLoginForm() {
        view.addSubview(loginForm)
        loginForm.accessibilityIdentifier = "LoginForm"
        loginForm.translatesAutoresizingMaskIntoConstraints = false
        loginForm.topAnchor.constraint(equalTo: segmentedController.bottomAnchor).isActive = true
        loginForm.widthAnchor.constraint(equalToConstant: userFormWidth).isActive = true
        loginFormCenterXConstraint = loginForm.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        loginFormCenterXConstraint.isActive = true
        loginFormBottomConstraint = loginForm.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        loginFormBottomConstraint.isActive = true
    }

    private func loginUser(email: String, password: String) {
        User.login(email: email, password: password)
            .done { [weak self] _ in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .catch { [weak self] error in
                DispatchQueue.main.async {
                    self?.presentErrorAlert(message: error.localizedDescription, buttonTitle: "Back")
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
        }
    }
}

// MARK: Register Form
extension AuthenticationViewController {
    private func setupRegisterForm() {
        view.addSubview(registerForm)
        registerForm.accessibilityIdentifier = "RegisterForm"
        registerForm.translatesAutoresizingMaskIntoConstraints = false
        registerForm.topAnchor.constraint(equalTo: segmentedController.bottomAnchor).isActive = true
        registerForm.leftAnchor.constraint(equalTo: loginForm.rightAnchor).isActive = true
        registerForm.widthAnchor.constraint(equalToConstant: userFormWidth).isActive = true
        registerFormBottomConstraint = registerForm.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        registerFormBottomConstraint.isActive = true
    }

    private func registerUser(attributes: [String: AWSCognitoIdentityUserAttributeType]) {
        let email     = attributes["email"]!
        let password  = attributes["password"]!
        User.register(email: email.value!, password: password.value!, attributes: [])
            .done { [weak self] _ in
                debugPrintMessage("Successfully Registered User")
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .catch { [weak self] error in
                var message = ""
                // swiftlint:disable force_cast
                switch (error as! User.RegistrationError) {
                case .emailExists:             message = "This email is already registered!."
                case .other(let errorMessage): message = errorMessage!
                }
                DispatchQueue.main.async {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    self?.presentErrorAlert(message: message, buttonTitle: "Back")
                }
        }
    }
}

// MARK: - AWSCognitoIdentityPasswordAuthentication Implementation
extension AuthenticationViewController: AWSCognitoIdentityPasswordAuthentication {
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput,
                    passwordAuthenticationCompletionSource:
        AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    }

    func didCompleteStepWithError(_ error: Error?) {
        if let authError = error as NSError?,
            let message = authError.userInfo["message"] as? String {
            DispatchQueue.main.async {
                switch authError.code {
                case 34: self.presentErrorAlert(message: "This email is not registered", buttonTitle: "Back")
                default: self.presentErrorAlert(message: message, buttonTitle: "Back")
                }
            }
        }
    }
}
