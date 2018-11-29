//
//  SpotSearchViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
import PassKit

import AWSDynamoDB

/// The SpotSearchViewController allows the user to search for a vacant parking spot.
class SpotSearchViewController: ViewController {
    private let guestParkingButton: OptionButton = create(OptionButton()) {
        $0.setTitle("Guest Parking", for: .normal)
        $0.addTarget(self, action: #selector(didSelectGuestParking), for: .touchUpInside)
    }
    private let registeredParkingButton: OptionButton = create(OptionButton()) {
        $0.setTitle("Registered Parking", for: .normal)
        $0.addTarget(self, action: #selector(didSelectRegisteredParking), for: .touchUpInside)
    }
    private var isSearchingForRegisteredParking: Bool = false
    /// True if the user cancels the search.
    private var searchCancelled: Bool = false
    private var vacantSpot: ParkingSpot?
    private var currentSpot: ParkingSpot?

    private var applePayController: PKPaymentAuthorizationViewController?
    private var transaction: Transaction?
    private var duration: ParkingSpot.Duration?

    // MARK: - ViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanLightGray
        let stackView = UIStackView(arrangedSubviews: [guestParkingButton,
                                                       registeredParkingButton])
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fillEqually
        stackView.spacing      = 20.0
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: 20.0).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                        constant: 20.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                          constant: -20.0).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                         constant: -20.0).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "Search"
    }

    // MARK: -

    @objc private func didSelectGuestParking(sender: UIButton) {
        sender.isEnabled = false
        defer { sender.isEnabled = true }
        isSearchingForRegisteredParking = false
        checkForCurrentParkingSpot()
    }

    @objc private func didSelectRegisteredParking(sender: UIButton) {
        sender.isEnabled = false
        defer { sender.isEnabled = true }
        isSearchingForRegisteredParking = true
        checkForCurrentParkingSpot()
    }

    // MARK: -

    /// Checks if the user is currently occupying a parking spot.
    /// If TRUE, then present the ParkingSpotViewController with the user's current parking spot.
    private func checkForCurrentParkingSpot() {
        let userId: String = User.currentUser!.username!
        let query = AWSDynamoDBQueryExpression()
        query.indexName = "occupant-index"
        query.keyConditionExpression    = "#occupant = :occupant"
        query.expressionAttributeNames  = ["#occupant": "occupant"]
        query.expressionAttributeValues = [":occupant": userId]
        Query<ParkingSpot>.get(expression: query)
            .done { [weak self] (parkingSpot: ParkingSpot) in
                self?.currentSpot = parkingSpot
                self?.presentCurrentOccupiedSpot()
            }
            .catch { [weak self] _ in
                self?.searchForVacantSpot()
        }
    }

    private func searchForVacantSpot() {
        presentSearchingAlert()
        ParkingSpot.getVacantSpot()
            .done { [weak self] vacantSpot in
                guard self?.searchCancelled != true else { return }
                self?.presentParkingSpotInformation(parkingSpot: vacantSpot)
            }
            .catch { [weak self] error in
                guard self?.searchCancelled != true else { return }
                if let fetchError = error as? Query.FetchError {
                    switch fetchError {
                    case .notFound:
                        self?.presentNoVacantSpotsFoundAlert()
                    case .other:
                        self?.presentErrorAlert(message: "An error occurred while searching for a vacant spot",
                                                buttonTitle: "Try Again")
                    }
                } else {
                    debugPrintMessage("SPOT SEARCH ERROR: \(error)")
                }
        }
    }

    // MARK: -

    /// Present an alert view notifying the user the search for a vacant spot is in progress.
    private func presentSearchingAlert() {
        // speak("Just a moment...")
        searchCancelled = false
        present(alertView: AlertView(style: .alert)) {
            $0.title = "Searching"
            $0.message = "Just a moment..."
            $0.confirmButton.setTitle("CANCEL", for: .normal)
            $0.confirmButton.backgroundColor = .spartanRed
            $0.confirmButton.rx.controlEvent(.touchUpInside)
                .subscribe({ _ in
                    self.dismissAlertView()
                    self.searchCancelled = true
                }).disposed(by: disposeBag)
        }
    }
    /// Dismises the searching alert view and present an AlertView with the vacant parking
    /// spot's information.
    ///
    /// - Parameters:
    ///     - parkingSpot: Fetched vacant parking spot.
    private func presentParkingSpotInformation(parkingSpot: ParkingSpot) {
        debugPrintMessage("Presenting spot found alert view")
        dismissAlertView()
        vacantSpot = parkingSpot
        speak("Spot Found at vacantSpot!.location")
        present(alertView: AlertView(style: .alert)) {
            $0.title = "Spot Found!"
            $0.message = parkingSpot.formattedLocation
            $0.messageLabel.lineBreakMode = .byWordWrapping
            $0.confirmButton.backgroundColor = .spartanGreen
            $0.confirmButton.setTitle("Arrived", for: .normal)
            $0.onConfirm {
                self.dismissAlertView()
                if self.isSearchingForRegisteredParking {
                    _ = self.vacantSpot?.occupy(occupant: User.currentUser!.username!)
                        .done { [weak self] _ in
                            self?.currentSpot = self?.vacantSpot
                            self?.vacantSpot = nil
                            self?.presentCurrentOccupiedSpot()
                        }.catch({ error in
                            debugPrintMessage(error)
                        })
                } else {
                   self.requestParkingSpotDuration()
                }
            }
        }
    }
    /// Present a duration picker to allow the user to park as a guest.
    private func requestParkingSpotDuration() {
        let pickerAlert = DurationPickerView()
        self.present(alertView: pickerAlert, setup: {
            $0.title = "Select Duration"
            $0.onCancel {
                self.dismissAlertView()
            }
        })
        pickerAlert.onConfirm {
            self.duration = pickerAlert.duration

            self.transaction                = Transaction()
            self.transaction?.transactionId = UUID().uuidString
            self.transaction?.userId        = User.currentUser!.username!
            self.transaction?.type          = Transaction.TransactionType.parking.rawValue
            self.transaction?.duration      = self.duration!.rawValue as NSNumber?
            self.transaction?.amount        = self.duration!.price
            self.transaction?.createdAt     = Date().description

            let paymentRequest = PKPaymentRequest()
            paymentRequest.merchantIdentifier   = PaymentConfigurations.merchantId
            paymentRequest.supportedNetworks    = PaymentConfigurations.supportedNetworks
            paymentRequest.merchantCapabilities = PaymentConfigurations.capabilities
            paymentRequest.countryCode          = PaymentConfigurations.countryCode
            paymentRequest.currencyCode         = PaymentConfigurations.currencyCode
            paymentRequest.paymentSummaryItems  = [
                PKPaymentSummaryItem(label: self.duration!.description, amount: self.duration!.price)
            ]

            self.applePayController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            self.applePayController?.delegate = self
            self.present(self.applePayController!, animated: true, completion: nil)
        }
    }
    /// Present an AlertView notifying the user that no vacant spots were found.
    ///
    /// The user will be presented with the option to:
    ///
    /// 1. Cancel the search
    /// 2. Try to search again.
    private func presentNoVacantSpotsFoundAlert() {
        debugPrintMessage("Presenting garages full alert view")
        speak("All garages are currently full!")
        dismissAlertView()
        present(alertView: AlertView(style: .confirmation)) {
            $0.title = "No Vacant Spot!"
            $0.message = "All garages are currently full!"
            $0.cancelButton!.setTitle("Cancel", for: .normal)
            $0.confirmButton.setTitle("Try Again", for: .normal)
            $0.onCancel {
                self.dismissAlertView()
            }
            $0.onConfirm {
                self.dismissAlertView()
                self.searchForVacantSpot()
            }
        }
    }

    private func presentCurrentOccupiedSpot() {
        present(alertView: AlertView(style: .alert)) {
            $0.title = "Current Spot"
            $0.message = currentSpot?.formattedLocation
            $0.confirmButton.backgroundColor = .spartanRed
            $0.confirmButton.setTitle("Leave", for: .normal)
            $0.onConfirm {
                self.currentSpot?.unOccupy()
                    .done { [weak self] _ in
                        self?.dismissAlertView()
                }
                    .catch { error in
                        debugPrintMessage(error)
                }
            }
        }
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate Implementation
extension SpotSearchViewController: PKPaymentAuthorizationViewControllerDelegate {
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
            _ = self.transaction?.save().done {
                _ = self.vacantSpot?.occupy(occupant: User.currentUser!.username!,
                                            duration: self.duration!)
                    .done { [weak self] _ in
                        self?.duration = nil
                        self?.currentSpot = self?.vacantSpot
                        self?.vacantSpot = nil
                        self?.presentCurrentOccupiedSpot()
                    }
                    .catch { error in
                        debugPrintMessage(error)
                    }
                }
                .catch { error in
                    debugPrintMessage(error)
            }
        }
    }
}
