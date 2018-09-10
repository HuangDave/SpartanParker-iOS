//
//  RegisterForm.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/5/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class RegisterForm: UserForm {
    let firstNameField    = TextField(placeHolder: "First",         key: "first_name")
    let lastNameField     = TextField(placeHolder: "Last",          key: "last_name")
    let emailField        = TextField(placeHolder: "Email",         key: "email")
    let passwordField     = TextField(placeHolder: "Password",      key: "password")
    let licensePlateField = TextField(placeHolder: "License Plate", key: "license_plate")

    override func setupForm() {
        emailField.inputField.keyboardType = .emailAddress
        passwordField.inputField.isSecureTextEntry = true

        let nameField = UIStackView(arrangedSubviews: [firstNameField, lastNameField])
        nameField.axis         = .horizontal
        nameField.alignment    = .fill
        nameField.distribution = .fillEqually
        nameField.spacing      = 20.0

        cells = [
            UserFormCell(content: nameField),
            UserFormCell(content: emailField),
            UserFormCell(content: passwordField),
            UserFormCell(content: licensePlateField),
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
