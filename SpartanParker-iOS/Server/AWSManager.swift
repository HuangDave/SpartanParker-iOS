//
//  AWSManager.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/5/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSCore
import AWSCognito
import AWSCognitoAuth
import AWSCognitoIdentityProvider

class AWSManager {
    static let region: AWSRegionType = .USEast2
    static let shared: AWSManager    = AWSManager()

    private(set) var serviceConfiguration:  AWSServiceConfiguration

    private init() {
        // setup Congnito Identity Pool Provider to use Cognito User Pool
        // refer to: https://docs.aws.amazon.com/cognito/latest/developerguide/tutorial-integrating-user-pools-ios.html
        serviceConfiguration = AWSServiceConfiguration(region: AWSManager.region,
                                                       credentialsProvider: Cognito.credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
    }
}

// MARK: - AWS Cognito Configurations
extension AWSManager {
    enum Cognito {
        enum Client {
            static let cliendId: String = ""
            static let secret:   String = ""
        }
        enum UserPool {
            static let key:    String = ""
            static let poolId: String = ""
        }
        enum IdentityPool {
            static let poodId: String = ""
        }

        static let credentialsProvider   = AWSCognitoCredentialsProvider(regionType: region,
                                                                         identityPoolId: IdentityPool.poodId)
        static let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: Client.cliendId,
                                                                                   clientSecret: Client.secret,
                                                                                   poolId: UserPool.poolId)
        static var userPool: AWSCognitoIdentityUserPool {
            return AWSCognitoIdentityUserPool(forKey: UserPool.key)
        }
    }

    func registerCognito() {
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration,
                                            userPoolConfiguration: Cognito.userPoolConfiguration,
                                            forKey: Cognito.UserPool.key)
    }
}
