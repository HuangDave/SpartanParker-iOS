//
//  User.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
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
    enum RegistrationError: Error {
        case emailExists(String)
    }

    class func register(email: String, password: String,
                        completion: @escaping (Bool) -> Void, failed: @escaping (RegistrationError) -> Void) {
        AuthenticationManager.shared.userPool
            .signUp(email, password: password, userAttributes: nil, validationData: nil)
            .continueWith { task -> Any? in
                if task.isCancelled {
                    debugPrintMessage("Registration cancelled.")
                } else if let error = task.error as NSError? {
                    debugPrintMessage("User.register(email:password:completion:failed:) - \(error)")
                    if error.code == 37, let message = error.userInfo["message"] as? String {
                        failed(RegistrationError.emailExists(message))
                    }
                } else if let result = task.result {
                    DispatchQueue.main.async {
                        debugPrintMessage(result)
                        completion(true)
                    }
                }
                return nil
        }
    }
}
