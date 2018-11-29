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

final class User: DatabaseObject {
    static let minimumPasswordLength: Int = 8
    class var currentUser: AWSCognitoIdentityUser? {
        return AWSManager.Cognito.userPool.currentUser()
    }

    @objc var userId: String!
    @objc var email: String!

    // MARK: - AWSDynamoDBModeling Overrides

    override class func dynamoDBTableName() -> String {
        return "User"
    }

    override class func hashKeyAttribute() -> String {
        return "userId"
    }

    class func get(userId: String) -> Promise<User> {
        let query = AWSDynamoDBQueryExpression()
        return Query<User>.get(expression: query)
    }
}

// MARK: - User Authentication
extension User {
    enum LoginError: Error {
        case notRegistered
        case invalidCredentials
        case unknown

        var localizedDescription: String {
            switch self {
            case .notRegistered:      return "This email is not registered!"
            case .invalidCredentials: return "Invalid email or password!"
            case .unknown:            return "Failed to login! Please try again."
            }
        }
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
                        debugPrintMessage(error)
                        switch error.code {
                        case 20: promise.reject(LoginError.invalidCredentials)
                        case 34: promise.reject(LoginError.notRegistered)
                        default: promise.reject(LoginError.unknown)
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
    /// Registers a new user. If registration is successfull, a new user entry and vehicle entry is
    /// added to the database.
    ///
    /// - Parameters:
    ///     - email:
    ///     - password:
    ///     - attributes: The attributes contains the user's:
    ///         1. SJSU ID
    ///         2. license plate
    ///
    /// - Returns: Returns the registered user as an AWSCognitoIdentityUser.
    final class func register(email: String, password: String,
                              licensePlate: String) -> Promise<AWSCognitoIdentityUser> {
        return Promise { promise in
            AWSManager.Cognito.userPool
                .signUp(email, password: password,
                        userAttributes: nil,
                        validationData: nil)
                .continueWith { task -> Any? in
                    if let error = task.error as NSError? {
                        switch error.code {
                        case 37: promise.reject(RegistrationError.emailExists)
                        default:
                            debugPrintMessage("User.register: failed) - \(error)")
                            let message = error.userInfo["message"] as? String
                            promise.reject(RegistrationError.other(message))
                        }
                    } else if task.result != nil,
                        let user = task.result?.user,
                        let userId = task.result?.userSub {
                        // Add the user's entry entry upon successfully registration.
                        let newUser = User()
                        newUser?.userId = userId
                        newUser?.email = email
                        newUser?.save()
                            .done {
                                let newVehicle = Vehicle()
                                newVehicle?.userId = userId
                                newVehicle?.licensePlate = licensePlate
                                _ = newVehicle?.save()
                                    .done {
                                        promise.fulfill(user)
                                    }
                                    .catch { error in
                                        debugPrintMessage(error)
                                        //promise.reject(error)
                                }
                            }.catch { error in
                                debugPrintMessage("User.register(email:password:attributes:) - Error \(error)")
                        }
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
    enum PasswordChangeError: Error {
        case tooShort
        case invalidOldPassword
        case doesNotMatch
        case unknown

        var localizedDescription: String {
            switch self {
            case .tooShort:           return "Password should be atleast \(User.minimumPasswordLength) characters long!"
            case .invalidOldPassword: return "The password does not match the current password on record!"
            case .doesNotMatch:       return "New Password does not match!"
            case .unknown:            return "Failed to update password. Please try again."
            }
        }
    }
    /// Change the current authenticated user's password. The new password should match the minimum required
    /// character length.
    ///
    /// - Parameters:
    ///     - oldPassword:     Current password.
    ///     - newPassword:     New proposed password.
    ///     - confirmPassword: Should match new password
    ///
    /// - Returns: Returns a Promise.
    final class func changePassword(oldPassword: String,
                                    newPassword: String,
                                    confirmPassword: String) -> Promise<Void> {
        return Promise { promise in
            guard newPassword == confirmPassword else {
                promise.resolve(PasswordChangeError.doesNotMatch)
                return
            }
            guard newPassword.count >= User.minimumPasswordLength else {
                promise.resolve(PasswordChangeError.tooShort)
                return
            }
            User.currentUser?.changePassword(oldPassword, proposedPassword: newPassword)
                .continueWith(block: { task -> Any? in
                    if let error = task.error as NSError? {
                        debugPrintMessage(error)
                        switch error.code {
                        case 20: promise.reject(PasswordChangeError.invalidOldPassword)
                        default: promise.reject(PasswordChangeError.unknown)
                        }
                    } else {
                        promise.resolve(nil)
                    }
                    return nil
                })
        }
    }
}
