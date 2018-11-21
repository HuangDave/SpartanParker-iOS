//
//  User.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

import AWSCognito
import AWSCognitoIdentityProvider
import AWSCore
import AWSDynamoDB
import PromiseKit

final class User: AWSDynamoDBObjectModel {
    class var currentUser: AWSCognitoIdentityUser? {
        return AWSManager.Cognito.userPool.currentUser()
    }

    /// 9-digit SJSU identifier
    @objc private(set) var userId:   String!
    @objc private(set) var email:    String?
    @objc private(set) var vehicles: [String] = []
}

// MARK: - AWSDynamoDBModeling Implementation
extension User: AWSDynamoDBModeling {
    class func dynamoDBTableName() -> String {
        return "User"
    }

    class func hashKeyAttribute() -> String {
        return "email"
    }
}

// MARK: - User Authentication
extension User {
    enum LoginError: Error {
        case invalidPassword
        case other(String?)
    }

    enum RegistrationError: Error {
        case emailExists
        case other(String?)
    }

    /// Authenticates the user through AWSCognito
    ///
    /// - Parameters:
    ///     - email:
    ///     - password:
    ///     - attributes:
    ///
    /// - Returns:
    final class func login(email: String, password: String) -> Promise<Void> {
        return Promise { promise in
            AWSManager.Cognito.userPool.getUser()
                .getSession(email, password: password, validationData: nil)
                .continueWith { task -> Any? in
                    if let error = task.error as NSError? {
                        switch error.code {
                        default: promise.reject(LoginError.other("Failed to login"))
                        }
                    } else {
                        debugPrintMessage("Successfully Authenticated User")
                        debugPrintMessage("Access Token: \(String(describing: task.result!.accessToken))")
                        debugPrintMessage("ID Token: \(String(describing: task.result?.idToken))")
                        debugPrintMessage("Refresh Token: \(String(describing: task.result?.refreshToken))")
                        promise.resolve(nil)
                    }
                    return nil
            }
        }
    }

    /// Registers a new user.
    ///
    /// - Parameters:
    ///     - email:
    ///     - password:
    ///     - attributes:
    ///
    /// - Returns:
    final class func register(email: String, password: String,
                              attributes: [AWSCognitoIdentityUserAttributeType]) -> Promise<AWSCognitoIdentityUser> {
        return Promise { promise in
            AWSManager.Cognito.userPool
                .signUp(email, password: password, userAttributes: attributes, validationData: nil)
                .continueWith { task -> Any? in
                    if let error = task.error as NSError? {
                        switch error.code {
                        case 37: promise.reject(RegistrationError.emailExists)
                        default:
                            debugPrintMessage("User.register: failed) - \(error)")
                            let message = error.userInfo["message"] as? String
                            promise.reject(RegistrationError.other(message))
                        }
                    } else if task.result != nil, let user = task.result?.user {
                        debugPrintMessage("Successfully registered user: \(user)")
                        promise.fulfill(user)
                    }
                    return nil
            }
        }
    }

    final class func logout() {
        AWSManager.Cognito.userPool.clearAll()
    }
}

// MARK: - Account Management
extension User {
    /// Change the current authenticated user's password.
    ///
    /// - Parameters:
    ///     - oldPassword: Current password.
    ///     - newPassword: New proposed password.
    ///
    /// - Returns: Returns a Promise.
    final class func changePassword(oldPassword: String, newPassword: String) -> Promise<Void> {
        return Promise { promise in
            User.currentUser?.changePassword(oldPassword, proposedPassword: newPassword)
                .continueWith(block: { task -> Any? in
                    promise.resolve(task.error)
                    return nil
                })
        }
    }
}
