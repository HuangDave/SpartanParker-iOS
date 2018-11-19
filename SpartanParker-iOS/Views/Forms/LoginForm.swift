//
//  LoginForm.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/4/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

import AWSCognitoIdentityProvider

class LoginForm: UserForm {
    let emailField:    TextField = TextField(placeHolder: "Email",    key: "email")
    let passwordField: TextField = TextField(placeHolder: "Password", key: "password")

    override func setupFields() {
        emailField.inputField.keyboardType = .emailAddress
        passwordField.inputField.isSecureTextEntry = true
        cells = [
            TableViewCell<UIView>(content: emailField, setup: defaultCellSetup),
            TableViewCell<UIView>(content: passwordField, setup: defaultCellSetup)
        ]
        reloadForm()
    }

    override func getAllInputs() throws -> [String : AWSCognitoIdentityUserAttributeType] {
        guard let email = emailField.text, !email.isEmpty else {
            throw TextField.InputError.emtpy("Email field cannot be empty!")
        }
        guard let password = passwordField.text, !password.isEmpty else {
            throw TextField.InputError.emtpy("Password field cannot be empty!")
        }
        return [
            // sjsuIdField.key:    AWSCognitoIdentityUserAttributeType(name: sjsuIdField.key,    value: sjsuId),
            emailField.key:     AWSCognitoIdentityUserAttributeType(name: emailField.key,     value: email),
            passwordField.key:  AWSCognitoIdentityUserAttributeType(name: passwordField.key,  value: password)
        ]
    }
}
