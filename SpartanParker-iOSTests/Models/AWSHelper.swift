//
//  AWSHelper.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 11/19/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSCore
import AWSCognito

@testable import SpartanParker_iOS

final class AWSHelper {
    enum User {
        static let sjsuId:      String = "009238996"
        static let email:       String = "huangd95@gmail.com"
        static let password:    String = "test1234"
        static let newPassword: String = "1234test"
        static let firstName:   String = "David"
        static let lastName:    String = "Huang"
    }

    static let shared = AWSHelper()

    private init() {
        AWSManager.shared.registerCognito()
    }

    class func authenticateUserIfNeeded() {
        let email    = User.email
        let password = User.password
        if AWSManager.Cognito.userPool.currentUser()?.isSignedIn == false {
            AWSManager.Cognito.userPool.currentUser()?
                .getSession(email, password: password, validationData: nil)
                .waitUntilFinished()
        }
    }
}
