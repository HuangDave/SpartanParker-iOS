//
//  Authenticator.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/5/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSCore
import AWSCognitoAuth
import AWSCognitoIdentityProvider

class Authenticator {
    enum Configuration {
        static let region: AWSRegionType = .USEast2
        // REMOVEME: Do not commit this
        enum Client {
            static let cliendId: String = ""
            static let secret:   String = ""
        }
        // REMOVEME: Do not commit this
        enum UserPool {
            static let key:    String = ""
            static let poolId: String = ""
        }
    }

    static let shared = Authenticator()

    private(set) var serviceConfiguration: AWSServiceConfiguration
    private(set) var userPoolConfiguration: AWSCognitoIdentityUserPoolConfiguration
    private(set) var userPool: AWSCognitoIdentityUserPool

    private init() {
        serviceConfiguration = AWSServiceConfiguration(region: Configuration.region,
                                                       credentialsProvider: nil)
        userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: Configuration.Client.cliendId,
                                                                        clientSecret: Configuration.Client.secret,
                                                                        poolId: Configuration.UserPool.poolId)
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration,
                                            userPoolConfiguration: userPoolConfiguration,
                                            forKey: Configuration.UserPool.key)
        userPool = AWSCognitoIdentityUserPool(forKey: Configuration.UserPool.key)
    }
}
