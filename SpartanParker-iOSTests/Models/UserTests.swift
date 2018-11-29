//
//  UserTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 11/19/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

import AWSCore
import AWSDynamoDB

@testable import SpartanParker_iOS

class UserTests: XCTestCase {
    override func setUp() {
        super.setUp()
        AWSHelper.authenticateUserIfNeeded()
    }

    override func tearDown() {
        // User.logout()
        super.tearDown()
    }

    func test_save() {
        let expect  = expectation(description: "Change password with incorrect old password")
        let timeout = 5.0
        var expectedError: Error?
        let user = User()
        user?.userId = "1234"
        user?.email = "test@email.com"
        user?.save()
            .done {
                expect.fulfill()
            }.catch { error in
                expectedError = error
                expect.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertNil(expectedError)
    }

    // MARK: - Password Change Tests
/*
    func test_changeIncorrectOldPassword() {
        let expect  = expectation(description: "Change password with incorrect old password")
        let timeout = 5.0
        let oldPassword = "incorrectPassword"
        let newPassword = AWSHelper.User.newPassword
        var expectedError: Error?
        User.changePassword(oldPassword: oldPassword, newPassword: newPassword)
            .done {
                expect.fulfill()
            }.catch { error in
                expectedError = error
                expect.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertNotNil(expectedError)
    }

    func test_changePassword() {
        XCTAssertTrue(User.currentUser!.isSignedIn)
        /*
        let expect  = expectation(description: "Change password with correct old password")
        let timeout = 5.0
        let oldPassword = AWSHelper.User.password
        let newPassword = AWSHelper.User.newPassword
        var expectedError: Error?
        User.changePassword(oldPassword: oldPassword, newPassword: newPassword)
            .done {
                expect.fulfill()
            }.catch { error in
                expectedError = error
                expect.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertNil(expectedError)
        // Reset password
        let resetExpect = expectation(description: "Change passwrod back")
        var resetError: Error?
        User.changePassword(oldPassword: newPassword, newPassword: oldPassword)
            .done {
                resetExpect.fulfill()
            }.catch { error in
                resetError = error
                resetExpect.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertNil(resetError) */
    }
*/
}
