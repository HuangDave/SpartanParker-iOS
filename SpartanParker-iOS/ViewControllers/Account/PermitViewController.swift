//
//  PermitViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 10/2/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import PassKit

// MARK: -
class PermitViewController: ViewController {
    private var permitOptions: [ParkingPermitCardView] = []
    private var applePayController: PKPaymentAuthorizationViewController?
    private var permitCardView: ParkingPermitCardView = ParkingPermitCardView()
    private var permit: ParkingPermit? {
        didSet {
            if permit != nil {
                permitCardView.permit = permit
            }
        }
    }

    // MARK: - ViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanLightGray

        let permitCardHeight: CGFloat = 240.0
        view.addSubview(permitCardView)
        permitCardView.translatesAutoresizingMaskIntoConstraints = false
        permitCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        permitCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        permitCardView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                             constant: 15.0).isActive = true
        permitCardView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                              constant: -15.0).isActive = true
        permitCardView.heightAnchor.constraint(equalToConstant: permitCardHeight)
            .isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.title = "Permit"
        fetchPermit()
    }

    // MARK: -

    private func fetchPermit() {
        guard let userId = User.currentUser?.username else {
            navigationController?.popViewController(animated: true)
            return
        }
        present(alertView: AlertView(style: .alert)) {
            $0.message = "Getting permit information."
            $0.confirmButton.backgroundColor = .spartanRed
            $0.confirmButton.setTitle("Back", for: .normal)
            $0.onConfirm {
                self.navigationController?.popViewController(animated: true)
            }
        }
        ParkingPermit.by(userId: userId)
            .done { [weak self] permit in
                DispatchQueue.main.async {
                    self?.dismissAlertView()
                    self?.permit = permit
                }
            }
            .catch { [weak self] error in
                DispatchQueue.main.async {
                    self?.dismissAlertView()
                    self?.presentNoPermitFoundAlert()
                }
        }
    }

    private func presentNoPermitFoundAlert() {
        present(alertView: AlertView(style: .confirmation)) {
            $0.message = "You currently do not have a parking permit. Would you like to purchase one?"
            $0.cancelButton?.setTitle("Back", for: .normal)
            $0.confirmButton.setTitle("Purchase", for: .normal)
            $0.onCancel {
                self.navigationController?.popViewController(animated: true)
            }
            $0.onConfirm {
                // TODO: present table view for permit purchase
            }
        }
    }

    private func didSelectPurchsePermit() {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = PaymentConfigurations.merchantId
        paymentRequest.supportedNetworks = PaymentConfigurations.supportedNetworks
        paymentRequest.merchantCapabilities = PaymentConfigurations.capabilities
        paymentRequest.countryCode = PaymentConfigurations.countryCode
        paymentRequest.currencyCode = PaymentConfigurations.currencyCode
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Semester Permit", amount: 200.00)
        ]
        applePayController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        applePayController?.delegate = self
        present(applePayController!, animated: true, completion: nil)
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate Implementation
extension PermitViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success,
                                                errors: []))
    }
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
