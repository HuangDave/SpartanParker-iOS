//
//  AppDelegate.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/4/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

import AWSCore
import AWSCognitoAuth
import AWSCognitoIdentityProvider

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private(set) var rootViewController: MasterViewController!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        AWSDDLog.sharedInstance.logLevel = .verbose
        #endif

        AWSManager.shared.registerCognito()
        // User.logout()
        AWSManager.Cognito.userPool.delegate = self
        if let user = AWSManager.Cognito.userPool.currentUser() {
            user.getDetails()
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        rootViewController = MasterViewController()
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        debugPrintMessage("AppDelegate:startPasswordAuthentication: Requesting Authentication from User...")
        let authenticationViewController = AuthenticationViewController()
        DispatchQueue.main.async {
            self.rootViewController.navigationController?.pushViewController(authenticationViewController,
                                                                             animated: true)
        }
        return authenticationViewController
    }
}
