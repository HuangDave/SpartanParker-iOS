//
//  RootViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/29/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
    
    private var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spotSearchController = SpotSearchViewController()
        spotSearchController.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 0)
        
        // TODO: change to actual controller
        let guestParkingController = UIViewController()
        guestParkingController.tabBarItem = UITabBarItem(title: "Scan", image: nil, tag: 1)
        
        // TODO: change to actual controller
        let historyController = UIViewController()
        historyController.tabBarItem = UITabBarItem(title: "History", image: nil, tag: 2)
        
        // TODO: change to actual controller
        let accountController = UIViewController()
        accountController.tabBarItem = UITabBarItem(title: "Account", image: nil, tag: 3)
        
        viewControllers = [
            spotSearchController,
            guestParkingController,
            historyController,
            accountController,
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard loggedIn == true else {
            loggedIn = true
            let autheticationController = AuthenticationViewController()
            navigationController?.present(autheticationController, animated: true, completion: nil)
            return
        }
    }
}
