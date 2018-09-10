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

    func presentAlert(message: String) {
        let alert = AlertView(style: .alert)
        alert.message = message
        alert.onConfirm {
            self.dismissAlertView()
        }
        presentAlertView(alert)
    }

    func presentAlertView(_ view: AlertView) {
        guard alertView == nil else {
            return
        }

        let horizontalPadding: CGFloat = 20.0
        alertView = view
        self.view.addSubview(alertView!)
        alertView!.translatesAutoresizingMaskIntoConstraints = false
        alertView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alertView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        alertView!.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                         constant: horizontalPadding).isActive = true
        alertView!.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                          constant: -(horizontalPadding)).isActive = true
        alertView!.heightAnchor.constraint(equalToConstant: alertView!.bounds.size.width).isActive = true
    }

    func dismissAlertView() {
        guard alertView != nil else { return }
        alertView?.removeFromSuperview()
        alertView = nil
    }
}
