//
//  MasterViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/29/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class MasterViewController: UITabBarController {
    private let spotSearchController = create(SpotSearchViewController()) {
        $0.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 0)
    }
    private let qrScanController: QRScanViewController = create(QRScanViewController()) {
        $0.tabBarItem = UITabBarItem(title: "Scan", image: nil, tag: 1)
    }
    // TODO: change to actual controller
    private let historyController: UIViewController = create(UIViewController()) {
        $0.tabBarItem = UITabBarItem(title: "History", image: nil, tag: 2)
    }
    // TODO: change to actual controller
    private let accountController: UIViewController = create(UIViewController()) {
        $0.tabBarItem = UITabBarItem(title: "Account", image: nil, tag: 3)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .white
        tabBar.tintColor = .spartanBlue
        tabBar.backgroundColor = .white
        viewControllers = [
            spotSearchController,
            qrScanController,
            historyController,
            accountController
            ]
    }
}
