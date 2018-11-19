//
//  LoginUITests.swift
//  SpartanParker-iOSUITests
//
//  Created by DAVID HUANG on 11/12/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

class LoginUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_invalidEmail() {
        let email    = "invalidemail@email.com"
        let password = "password"

        let app = XCUIApplication()
        let tablesQuery = app.otherElements.containing(.navigationBar, identifier:"Search")
            .children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element(boundBy: 1).tables
        let alertView = app.otherElements["ErrorAlertView"]

        XCTAssertTrue(app.otherElements["LoginForm"].exists)

        // input invalid email and attempt to login
        tablesQuery.textFields["Email"].tap()
        email.forEach({
            app.keys[String($0)].tap()
        })
        tablesQuery.secureTextFields["Password"].tap()
        password.forEach({
            app.keys[String($0)].tap()
        })
        app.navigationBars["Search"].buttons["Done"].tap()

        XCTAssertTrue(alertView.exists)
        XCTAssertTrue(alertView.buttons["Back"].exists)
        app.buttons["Back"].tap()

        XCTAssertFalse(alertView.exists)
        XCTAssertTrue(app.otherElements["LoginForm"].exists)
    }

    func test_register() {
        let sjsuId       = "123456789"
        let firstName    = "David"
        let lastName     = "Huang"
        let email        = "huangd95@gmail.com"
        let password     = "test1234"
        let licensePlate = "ab1234c"

        let app = XCUIApplication()
        let tablesQuery = app.otherElements["RegisterForm"].tables

        let sjsuIdField       = tablesQuery.textFields["registerSjsuIdField"]
        let firstNameField    = tablesQuery.textFields["registerFirstNameField"]
        let lastNameField     = tablesQuery.textFields["registerLastNameField"]
        let emailField        = tablesQuery.textFields["registerEmailField"]
        let passwordField     = tablesQuery.textFields["registerPasswordField"]
        let licensePlateField = tablesQuery.textFields["registerLicensePlateField"]

        app.buttons["Register"].tap()

        sjsuIdField.tap()

        firstNameField.tap()
        firstName.forEach {
            app.keys[String($0)].tap()
        }
        lastNameField.tap()
        lastName.forEach {
            app.keys[String($0)].tap()
        }

        emailField.tap()
        email.forEach {
            let char = String($0)
            if char == "@" || char == "9" || char == "5" {
                app.keys["more"].tap()
            }
            app.keys[String($0)].tap()
        }

        passwordField.tap()
        password.forEach {
            app.keys[String($0)].tap()
        }
    }

    func test_validCredentials() {
        let email = "huangd95@gmail.com"
        let password = "test1234"
    }
}
