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

// MARK: -
class User: DatabaseObject {
    private enum CodingKeys: String, CodingKey {
        case fullName
        case email
        case password
    }

    private enum FullNameKeys: String, CodingKey {
        case first
        case last
    }

    struct FullName: Codable {
        var first: String?
        var last:  String?
    }

    var fullName: FullName?
    var email:    String?
    var password: String?

    required init(from decoder: Decoder) throws {
        let container         = try decoder.container(keyedBy: CodingKeys.self)
        let fullNameContainer = try container.nestedContainer(keyedBy: FullNameKeys.self,
                                                              forKey: .fullName)
        fullName?.first       = try fullNameContainer.decode(String.self, forKey: .first)
        fullName?.last        = try fullNameContainer.decode(String.self, forKey: .last)
        email                 = try container.decode(String.self, forKey: .email)
        password              = try container.decode(String.self, forKey: .password)
        try super.init(from: decoder)
    }

    override func serialized() -> JSON {
        var data = super.serialized()
        data[CodingKeys.fullName.rawValue] = [
            FullNameKeys.first.rawValue: fullName?.first,
            FullNameKeys.last.rawValue:  fullName?.last
        ]
        data[CodingKeys.email.rawValue]    = email
        data[CodingKeys.password.rawValue] = password
        return data
    }
}

// MARK: -
extension User {
    enum LoginError: Error {
        case invalidPassword
        case other(String?)
    }

    enum RegistrationError: Error {
        case emailExists
        case other(String?)
    }

    class func login(email: String, password: String,
                     attributes: [AWSCognitoIdentityUserAttributeType],
                     success: @escaping () -> Void,
                     failure: @escaping (LoginError) -> Void) {
        AWSManager.Cognito.userPool.getUser()
            .getSession(email,
                        password: password,
                        validationData: attributes)
            .continueWith { task -> Any? in
                if let error = task.error as NSError? {
                    switch error.code {
                    default: failure(LoginError.other("Failed to login"))
                    }
                } else {
                    DispatchQueue.main.async {
                        success()
                    }
                }
                return nil
        }
    }

    class func register(email: String, password: String,
                        attributes: [AWSCognitoIdentityUserAttributeType],
                        success: @escaping () -> Void,
                        failure: @escaping (RegistrationError) -> Void) {
        AWSManager.Cognito.userPool
            .signUp(email, password: password, userAttributes: attributes, validationData: nil)
            .continueWith { task -> Any? in
                if let error = task.error as NSError? {
                    switch error.code {
                    case 37: failure(RegistrationError.emailExists)
                    default:
                        debugPrintMessage("User.register(email:password:completion:failed:) - \(error)")
                        let message = error.userInfo["message"] as? String
                        failure(RegistrationError.other(message))
                    }
                } else if let result = task.result {
                    DispatchQueue.main.async {
                        success()
                    }
                }
                return nil
        }
    }

    class func logout() {
        AWSManager.Cognito.userPool.currentUser()?.globalSignOut()
        AWSManager.Cognito.userPool.currentUser()?.signOutAndClearLastKnownUser()
        AWSCognito.default().wipe()
    }
}
