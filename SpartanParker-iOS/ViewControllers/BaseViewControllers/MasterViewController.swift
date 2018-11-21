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
        $0.tabBarItem = UITabBarItem(title: "Search",
                                     image: UIImage(named: "search"),
                                     selectedImage: UIImage(named: "search_selected"))
    }
    private let qrScanController: QRScanViewController = create(QRScanViewController()) {
        $0.tabBarItem = UITabBarItem(title: "Scan",
                                     image: UIImage(named: "scan"),
                                     selectedImage: UIImage(named: "scan_selected"))
    }
    // TODO: change to actual controller
    private let historyController: UIViewController = create(UIViewController()) {
        $0.tabBarItem = UITabBarItem(title: "History",
                                     image: UIImage(named: "history"),
                                     selectedImage: UIImage(named: "history_selected"))
    }
    private let accountController: AccountViewController = create(AccountViewController()) {
        $0.tabBarItem = UITabBarItem(title: "Account",
                                     image: UIImage(named: "account"),
                                     selectedImage: UIImage(named: "account_selected"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
