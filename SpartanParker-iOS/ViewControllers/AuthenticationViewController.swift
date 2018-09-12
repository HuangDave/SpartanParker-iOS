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
    /// Constraint used for animating the switch between the login and register forms.
    private var loginFormCenterXConstraint:    NSLayoutConstraint!
    ///
    private var loginFormBottomConstraint:     NSLayoutConstraint!
    private var registerFormBottomConstraint:  NSLayoutConstraint!

    private var currentForm: AuthenticationForm = AuthenticationForm.login

    private var userFormWidth: CGFloat { return view.frame.width }

    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?

    // MARK: - UIViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        loginForm.delegate = self
        view.addSubview(loginForm)
        loginForm.translatesAutoresizingMaskIntoConstraints = false
        loginForm.topAnchor.constraint(equalTo: segmentedController.bottomAnchor).isActive = true
        loginForm.widthAnchor.constraint(equalToConstant: userFormWidth).isActive = true
        loginFormCenterXConstraint = loginForm.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        loginFormCenterXConstraint.isActive = true
        loginFormBottomConstraint = loginForm.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        loginFormBottomConstraint.isActive = true

        #if DEBUG
        loginForm.emailField.text    = "huangd95@yahoo.com"
        loginForm.passwordField.text = "Test1234"
        #endif
    }

    private func createRegisterForm() {
        registerForm.delegate = self
        view.addSubview(registerForm)
        registerForm.translatesAutoresizingMaskIntoConstraints = false
        registerForm.topAnchor.constraint(equalTo: segmentedController.bottomAnchor).isActive = true
        registerForm.leftAnchor.constraint(equalTo: loginForm.rightAnchor).isActive = true
        registerForm.widthAnchor.constraint(equalToConstant: userFormWidth).isActive = true
        registerFormBottomConstraint = registerForm.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        registerFormBottomConstraint.isActive = true

        #if DEBUG
        registerForm.emailField.text        = "huangd95@yahoo.com"
        registerForm.passwordField.text     = "Test1234"
        registerForm.firstNameField.text    = "David"
        registerForm.lastNameField.text     = "Huang"
        registerForm.licensePlateField.text = "123sd94"
        #endif
    }

    func userFormDidSelectContinue(_ userForm: UserForm) {
        view.endEditing(true)
        // attempt to get input information and present an alert if any field was empty or invalid
        var formInformation: [String: String]?
        var errorDescription: String?
        do {
            formInformation = try userForm.getAllInputs()
        } catch TextField.InputError.emtpy(let description) {
            errorDescription = description
        } catch TextField.InputError.invalid(let description) {
            errorDescription = description
        } catch _ { return }

        if let message = errorDescription {
            self.present(alertView: AlertView(style: .alert), setup: {
                $0.message = message
                // TODO: refactor
                $0.confirmButton.setTitle("BACK", for: .normal)
                $0.confirmButton.backgroundColor = .spartanRed
                $0.onConfirm {
                    self.dismissAlertView()
                }
            })
            return
        }

        #if DEBUG
        let email:    String = "huangd95@yahoo.com"
        let password: String = "Test1234"
        #else
        let email:    String = formInformation!["email"]!
        let password: String = formInformation!["password"]!
        #endif

        switch userForm {
        case loginForm:
            DispatchQueue.main.async {
                let details = AWSCognitoIdentityPasswordAuthenticationDetails(username: email,
                                                                              password: password)
                self.passwordAuthenticationCompletion?.set(result: details)
                self.passwordAuthenticationCompletion?.task.continueWith(block: { [weak self] task -> Any? in
                    if task.isCompleted {
                        debugPrintMessage("Successfully authenticated user...")
                        self?.dismiss(animated: true, completion: nil)
                    } else if let error = task.error as NSError? {
                        debugPrintMessage(error)
                        // TODO: handle authe error
                    }
                    return nil
                })
            }
        case registerForm:
            User.register(email: email,
                          password: password,
                          completion: ({ _ in
                            self.dismiss(animated: true, completion: nil)
                          }), failed: { [weak self] error in
                            switch error {
                            case .emailExists(let message):
                                DispatchQueue.main.async {
                                    self?.present(alertView: AlertView(style: .alert), setup: {
                                        $0.message = message
                                        // TODO: refactor
                                        $0.confirmButton.setTitle("BACK", for: .normal)
                                        $0.confirmButton.backgroundColor = .spartanRed
                                        $0.onConfirm {
                                            self?.dismissAlertView()
                                        }
                                    })
                                }
                            }
            })
        default: return
        }
    }
}

// MARK: -
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
                self.present(alertView: AlertView(style: .alert), setup: {
                    $0.message = message
                    // TODO: refactor
                    $0.confirmButton.setTitle("BACK", for: .normal)
                    $0.confirmButton.backgroundColor = .spartanRed
                    $0.onConfirm {
                        self.dismissAlertView()
                    }
                })
            }
        }
    }
}
