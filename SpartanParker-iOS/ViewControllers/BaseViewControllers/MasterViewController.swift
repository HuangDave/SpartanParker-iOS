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
    private let transactionController = create(TransactionViewController()) {
        $0.tabBarItem = UITabBarItem(title: "History",
                                     image: UIImage(named: "history"),
                                     selectedImage: UIImage(named: "history_selected"))
    }
    private let accountController = create(AccountViewController()) {
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
            // qrScanController,
            transactionController,
            accountController
        ]
    }
}
