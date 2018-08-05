//
//  LoginViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/5/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var tfEmail: UITextField!
    @IBOutlet private weak var tfPassword: UITextField!
    
    @IBAction private func userDidTapContinue(sender: UIButton) {
        guard let email = tfEmail.text else {
            return
        }
        guard let password = tfPassword.text else {
            return
        }
        
        // TODO: verify email and password fields are valid
        
        // TODO: authenticate user
    }
}
