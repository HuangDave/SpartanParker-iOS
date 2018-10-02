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

    var rootViewController: MasterViewController!
    var authenticationViewController: AuthenticationViewController?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AuthenticationManager.shared.userPool.delegate = self
        // REMOVEME: remove this if not testing auth
        // AuthenticationManager.shared.userPool.currentUser()?.globalSignOut()

        window = UIWindow(frame: UIScreen.main.bounds)
        rootViewController = MasterViewController()
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        debugPrintMessage("Requesting Authentication from User...")
        if authenticationViewController == nil {
            authenticationViewController = AuthenticationViewController()
        }
        DispatchQueue.main.async {
            self.rootViewController.navigationController?.pushViewController(self.authenticationViewController!,
                                                                             animated: true)
        }
        return authenticationViewController!
    }
}
