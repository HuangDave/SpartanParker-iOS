//
//  ViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var alertView: AlertView?

    func present(alertView: AlertView, setup: (AlertView) -> Void) {
        setup(alertView)
        let horizontalPadding: CGFloat = 20.0
        self.alertView = alertView
        view.addSubview(self.alertView!)
        self.alertView!.translatesAutoresizingMaskIntoConstraints = false
        self.alertView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.alertView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.alertView!.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                             constant: horizontalPadding).isActive = true
        self.alertView!.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                              constant: -(horizontalPadding)).isActive = true
        self.alertView!.heightAnchor.constraint(equalToConstant: self.alertView!.bounds.size.width).isActive = true
    }

    func dismissAlertView() {
        guard alertView != nil else { return }
        alertView?.removeFromSuperview()
        alertView = nil
    }
}
