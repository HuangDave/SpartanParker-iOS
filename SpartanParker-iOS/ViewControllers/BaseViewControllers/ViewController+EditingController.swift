//
//  ViewController+EditingController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/28/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

// MARK: - EditingController Protocol
protocol EditingController: AnyObject {
    var dimView: UIView? { get }
    var alertView: AlertView? { get }

    func didSelectSave()

    func presentEditConfirmationAlert(_ closure: @escaping (_ confirmed: Bool) -> Void)
    func presentSavedAlert(_ onConfirm: @escaping () -> Void)
}

// MARK: - EditingController Implementation for ViewController
extension EditingController where Self: ViewController {
    func presentEditConfirmationAlert(_ closure: @escaping (_ cancelled: Bool) -> Void) {
        present(alertView: AlertView(style: .confirmation)) {
            $0.title = "Save Changes?"
            $0.message = "Are you sure you want to save these changes?"
            $0.onCancel {
                self.dismissAlertView()
                closure(true)
            }
            $0.onConfirm {
                self.dismissAlertView()
                closure(false)
            }
        }
    }

    func presentSavedAlert(_ onConfirm: @escaping () -> Void) {
        present(alertView: AlertView(style: .alert)) {
            $0.message = "Saved!"
            $0.confirmButton.titleLabel?.text = "OK"
            $0.onConfirm {
                onConfirm()
            }
        }
    }
}
