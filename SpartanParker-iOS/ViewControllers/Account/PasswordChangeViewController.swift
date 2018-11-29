//
//  PasswordChangeViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

import PromiseKit

class PasswordChangeViewController: ViewController {
    let oldPasswordField = create(TextField(placeHolder: "Old Password", key: "old_password")) {
        $0.inputField.isSecureTextEntry = true
    }
    let newPasswordField = create(TextField(placeHolder: "New Password", key: "new_password")) {
        $0.inputField.isSecureTextEntry = true
    }
    let confirmPasswordField = create(TextField(placeHolder: "Confirm Password", key: "confirm_password")) {
        $0.inputField.isSecureTextEntry = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanLightGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(didSelectSave))
        view.addSubview(oldPasswordField)
        view.addSubview(newPasswordField)
        view.addSubview(confirmPasswordField)

        configureConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.title = "Password"
    }

    private func configureConstraints() {
        let topSpacing:        CGFloat = 32.0
        let verticalSpacing:   CGFloat = 16.0
        let horizontalPadding: CGFloat = 25.0
        oldPasswordField.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: topSpacing).isActive = true
        oldPasswordField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                constant: horizontalPadding).isActive = true
        oldPasswordField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                 constant: -horizontalPadding).isActive = true
        oldPasswordField.heightAnchor.constraint(equalToConstant: TextField.defaultHeight).isActive = true

        newPasswordField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordField.topAnchor.constraint(equalTo: oldPasswordField.bottomAnchor,
                                              constant: verticalSpacing).isActive = true
        newPasswordField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                               constant: horizontalPadding).isActive = true
        newPasswordField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                constant: -horizontalPadding).isActive = true
        newPasswordField.heightAnchor.constraint(equalToConstant: TextField.defaultHeight).isActive = true

        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordField.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor,
                                               constant: verticalSpacing).isActive = true
        confirmPasswordField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                constant: horizontalPadding).isActive = true
        confirmPasswordField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                 constant: -horizontalPadding).isActive = true
        confirmPasswordField.heightAnchor.constraint(equalToConstant: TextField.defaultHeight).isActive = true
    }

    @objc func didSelectSave() {
        view.endEditing(true)

        guard let oldPassword = oldPasswordField.text,
            let newPassword = newPasswordField.text,
            let confirmPassword = confirmPasswordField.text else {
                presentErrorAlert(message: "Fields must not be empty!", buttonTitle: "Back")
                return
        }
        _ = User.changePassword(oldPassword: oldPassword,
                                newPassword: newPassword,
                                confirmPassword: confirmPassword)
            .done { [weak self] _ in
                self?.present(alertView: AlertView(style: .alert), setup: {
                    $0.message = "Password Updated!"
                    $0.confirmButton.backgroundColor = .spartanGreen
                    $0.confirmButton.titleLabel?.text = "OK"
                    $0.onConfirm {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }.catch { [weak self] error in
                // swiftlint:disable force_cast
                self?.presentErrorAlert(message: (error as! User.PasswordChangeError).localizedDescription,
                                        buttonTitle: "Try Again")
        }
    }
}
