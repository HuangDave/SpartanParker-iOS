//
//  RegisterForm.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/5/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

import AWSCognitoIdentityProvider
import RxCocoa
import RxSwift

class RegisterForm: UserForm {

    let sjsuIdField = create(TextField(placeHolder: "SJSU ID", key: "sjsuId")) {
        $0.inputField.accessibilityIdentifier = "registerSjsuIdField"
        $0.inputField.keyboardType = .numberPad
    }
    let firstNameField = create(TextField(placeHolder: "First", key: "firstName")) {
        $0.inputField.accessibilityIdentifier = "registerFirstNameField"
    }
    let lastNameField = create(TextField(placeHolder: "Last", key: "lastName")) {
        $0.inputField.accessibilityIdentifier = "registerLastNameField"
    }
    let emailField = create(TextField(placeHolder: "Email", key: "email")) {
        $0.inputField.accessibilityIdentifier = "registerEmailField"
        $0.inputField.keyboardType = .emailAddress
    }
    let passwordField = create(TextField(placeHolder: "Password", key: "password")) {
        $0.inputField.accessibilityIdentifier = "registerPasswordField"
        $0.inputField.isSecureTextEntry = true
    }
    let licensePlateField = create(TextField(placeHolder: "License Plate", key: "licensePlate")) {
        $0.inputField.accessibilityIdentifier = "regsiterLicensePlateField"
    }

    var disposeBag = DisposeBag()

    override func setupFields() {
        sjsuIdField.inputField.rx.controlEvent(.editingChanged)
            .subscribe({ _ in
                let maxSjsuIdLength: Int = 9
                if let text = self.sjsuIdField.inputField.text {
                    self.sjsuIdField.inputField.text = String(text.prefix(maxSjsuIdLength))
                }
            }).disposed(by: disposeBag)
        passwordField.inputField.rx.controlEvent(.editingDidBegin)
            .subscribe ({ _ in
                self.shiftFormUp()
            }).disposed(by: disposeBag)

        licensePlateField.inputField.rx.controlEvent(.editingChanged)
            .subscribe({ _ in
                let maxLicensePlateLength: Int = 7
                if let text = self.licensePlateField.inputField.text {
                    self.licensePlateField.inputField.text = String(text.prefix(maxLicensePlateLength))
                }
            }).disposed(by: disposeBag)
        licensePlateField.inputField.rx.controlEvent(.editingDidBegin)
            .subscribe({ _ in
                self.shiftFormUp()
        }).disposed(by: disposeBag)

        passwordField.inputField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe { _ in
                self.shiftFormDown()
            }.disposed(by: disposeBag)
        licensePlateField.inputField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe { _ in
                self.shiftFormDown()
            }.disposed(by: disposeBag)

        let nameField = UIStackView(arrangedSubviews: [firstNameField, lastNameField])
        nameField.axis         = .horizontal
        nameField.alignment    = .fill
        nameField.distribution = .fillEqually
        nameField.spacing      = 20.0

        cells = [
            TableViewCell<UIView>(content: sjsuIdField, setup: defaultCellSetup),
            TableViewCell<UIView>(content: nameField, setup: defaultCellSetup),
            TableViewCell<UIView>(content: emailField, setup: defaultCellSetup),
            TableViewCell<UIView>(content: passwordField, setup: defaultCellSetup),
            TableViewCell<UIView>(content: licensePlateField, setup: defaultCellSetup)
        ]
        reloadForm()
    }

    override func getAllInputs() throws -> [String : AWSCognitoIdentityUserAttributeType] {
        guard let sjsuId = sjsuIdField.text, !sjsuId.isEmpty else {
            throw TextField.InputError.emtpy("SJSU ID field cannot be empty!")
        }
        guard let firstName = firstNameField.text, !firstName.isEmpty else {
            throw TextField.InputError.emtpy("Name field cannot be empty!")
        }
        guard let lastName = lastNameField.text, !lastName.isEmpty else {
            throw TextField.InputError.emtpy("Name field cannot be empty!")
        }
        guard let email = emailField.text, !email.isEmpty else {
            throw TextField.InputError.emtpy("Email field cannot be empty!")
        }
        guard let password = passwordField.text, !password.isEmpty else {
            throw TextField.InputError.emtpy("Password field cannot be empty!")
        }
        guard let licensePlate = licensePlateField.text, !licensePlate.isEmpty else {
            throw TextField.InputError.emtpy("Password field cannot be empty!")
        }
        return [
            sjsuIdField.key:    AWSCognitoIdentityUserAttributeType(name: sjsuIdField.key,
                                                                    value: sjsuId),
            firstNameField.key: AWSCognitoIdentityUserAttributeType(name: firstNameField.key,
                                                                    value: firstName),
            lastNameField.key:  AWSCognitoIdentityUserAttributeType(name: lastNameField.key,
                                                                    value: lastName),
            emailField.key:     AWSCognitoIdentityUserAttributeType(name: emailField.key,
                                                                    value: email),
            passwordField.key:  AWSCognitoIdentityUserAttributeType(name: passwordField.key,
                                                                    value: password),
            licensePlateField.key: AWSCognitoIdentityUserAttributeType(name: licensePlateField.key,
                                                                       value: licensePlate)
        ]
    }

    func shiftFormUp() {
        self.tableViewBottomConstraint.constant = -260.0
        self.layoutIfNeeded()
    }

    func shiftFormDown() {
        self.tableViewBottomConstraint.constant = 0
        self.layoutIfNeeded()
    }
}
