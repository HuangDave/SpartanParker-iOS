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
    
    func presentAlertView(_ alertView: AlertView) {
        guard self.alertView == nil else {
            print("Already displaying an AlertView!")
            return
        }
        
        let horizontalPadding: CGFloat = 20.0
        
        self.alertView = alertView
        
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalPadding).isActive = true
        alertView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -(horizontalPadding)).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: alertView.bounds.size.width).isActive = true
    }
    
    func dismissAlertView() {
        
        guard alertView != nil else { return }
        
        alertView?.removeFromSuperview()
        alertView = nil
    }
}

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
