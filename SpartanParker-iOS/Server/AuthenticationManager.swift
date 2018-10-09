//
//  AuthenticationManager.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/5/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSCore
import AWSCognitoAuth
import AWSCognitoIdentityProvider

class AuthenticationManager {
    enum CognitoConfigurations {
        static let region: AWSRegionType = .USEast2
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
    }

    static let shared = AuthenticationManager()

    private(set) var serviceConfiguration:  AWSServiceConfiguration
    private(set) var userPoolConfiguration: AWSCognitoIdentityUserPoolConfiguration
    private(set) var userPool:              AWSCognitoIdentityUserPool
    private(set) var credentialsProvider:   AWSCognitoCredentialsProvider

    private init() {
        // setup Congnito Identity Pool Provider to use Cognito User Pool
        // refer to: https://docs.aws.amazon.com/cognito/latest/developerguide/tutorial-integrating-user-pools-ios.html
        credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoConfigurations.region,
                                                            identityPoolId: CognitoConfigurations.IdentityPool.poodId)
        // TODO: should use credentialsProvider for IdentityPool
        serviceConfiguration = AWSServiceConfiguration(region: CognitoConfigurations.region,
                                                       credentialsProvider: nil) // credentialsProvider)
        userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoConfigurations.Client.cliendId,
                                                                        clientSecret: CognitoConfigurations.Client.secret,
                                                                        poolId: CognitoConfigurations.UserPool.poolId)
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration,
                                            userPoolConfiguration: userPoolConfiguration,
                                            forKey: CognitoConfigurations.UserPool.key)
        userPool = AWSCognitoIdentityUserPool(forKey: CognitoConfigurations.UserPool.key)
        AWSServiceManager.default()?.defaultServiceConfiguration = serviceConfiguration
    }
}
