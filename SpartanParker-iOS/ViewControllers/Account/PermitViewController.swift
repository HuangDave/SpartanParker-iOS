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
        let padding: CGFloat = 15.0
        view.addSubview(permitCardView)
        permitCardView.translatesAutoresizingMaskIntoConstraints = false
        permitCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        permitCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        permitCardView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                             constant: padding).isActive = true
        permitCardView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                              constant: -padding).isActive = true
        permitCardView.heightAnchor.constraint(equalToConstant: permitCardHeight).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.title = "Permit"
        fetchPermit()
    }

    // MARK: -

    private func fetchPermit() {
        guard let userId: String = User.currentUser?.username else {
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
        debugPrintMessage("userId: \(userId))")
        ParkingPermit.by(userId: userId)
            .done { [weak self] permit in
                debugPrintMessage(permit)
                DispatchQueue.main.async {
                    self?.dismissAlertView()
                    self?.permit = permit
                }
            }
            .catch { [weak self] error in
                debugPrintMessage("PERMIT FETCH ERROR: \(error)")
                DispatchQueue.main.async {
                    self?.dismissAlertView()
                    self?.presentNoPermitFoundAlert()
                }
        }
    }

    private func presentNoPermitFoundAlert() {
        present(alertView: AlertView(style: .confirmation)) {
            $0.message = "You currently do not have a parking permit. " +
                         "Would you like to purchase a semester permit?"
            $0.cancelButton?.setTitle("Back", for: .normal)
            $0.confirmButton.setTitle("Purchase", for: .normal)
            $0.onCancel {
                self.navigationController?.popViewController(animated: true)
            }
            $0.onConfirm {
                self.didSelectPurchsePermit()
            }
        }
    }

    private func didSelectPurchsePermit() {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier   = PaymentConfigurations.merchantId
        paymentRequest.supportedNetworks    = PaymentConfigurations.supportedNetworks
        paymentRequest.merchantCapabilities = PaymentConfigurations.capabilities
        paymentRequest.countryCode          = PaymentConfigurations.countryCode
        paymentRequest.currencyCode         = PaymentConfigurations.currencyCode
        paymentRequest.paymentSummaryItems  = [
            PKPaymentSummaryItem(label: "Semester Permit", amount: ParkingPermit.PermitType.student.price)
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
        controller.dismiss(animated: true) {
            self.applePayController = nil
            self.dismissAlertView()

            let userId = User.currentUser!.username!
            let currentDate = Date()

            let transaction            = Transaction()
            transaction?.transactionId = UUID().uuidString
            transaction?.userId        = User.currentUser!.username!
            transaction?.type          = Transaction.TransactionType.permitPurchase.rawValue
            transaction?.amount        = ParkingPermit.PermitType.student.price
            transaction?.createdAt     = currentDate.description

            _ = Vehicle.get(userId: userId).done { vehicle in
                let permit = ParkingPermit()
                permit?.permitId = UUID().uuidString
                permit?.userId = userId
                permit?.licensePlate = vehicle.licensePlate
                permit?.type = ParkingPermit.PermitType.student.rawValue
                permit?.createdAt = currentDate.description
                permit?.expirationDate = currentDate.addingTimeInterval(180 * 24 * 60 * 60).description

                _ = permit?.save().done { _ in
                    _ = transaction?.save()
                }
            }
        }
    }
}
