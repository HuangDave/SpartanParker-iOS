//
//  LoginForm.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/4/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class LoginForm: UserForm {
    let emailField:    TextField = TextField(placeHolder: "Email",    key: "email")
    let passwordField: TextField = TextField(placeHolder: "Password", key: "password")

    override func setupForm() {
        emailField.inputField.keyboardType = .emailAddress
        passwordField.inputField.isSecureTextEntry = true
        cells = [
            UserFormCell(content: emailField),
            UserFormCell(content: passwordField),
            UserFormCell(content: continueButton)
        ]
        reloadForm()
    }

    override func getAllInputs() throws -> [String : String] {
        guard let email = emailField.text, !email.isEmpty else {
            throw TextField.InputError.emtpy("Email field cannot be empty!")
        }
        guard let password = passwordField.text, !password.isEmpty else {
            throw TextField.InputError.emtpy("Password field cannot be empty!")
        }
        return [
            emailField.key:    email,
            passwordField.key: password
        ]
    }
}
