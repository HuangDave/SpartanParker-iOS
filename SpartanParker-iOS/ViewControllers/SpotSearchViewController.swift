//
//  SpotSearchViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

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

    /// True if the user cancels the search.
    private var searchCancelled: Bool = false

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

    @objc private func didSelectGuestParking(sender: UIButton) {
        sender.isEnabled = false
        defer { sender.isEnabled = true }
        //presentSearchingAlert()
    }

    @objc private func didSelectRegisteredParking(sender: UIButton) {
        sender.isEnabled = false
        defer { sender.isEnabled = true }
        searchForVacantSpot()
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
                if let fetchError = error as? ParkingSpot.FetchError {
                    switch fetchError {
                    case .noVacantSpot:
                        self?.presentNoVacantSpotsFoundAlert()
                    case .other:
                        self?.presentErrorAlert(message: "An error occurred while searching for a vacant spot",
                                                buttonTitle: "Try Again")
                    }
                } else {
                    // TODO:
                }
        }
    }

    // MARK: - Alert Views

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
    /// spot's information
    ///
    /// - Parameters:
    ///     - parkingSpot: Fetched vacant parking spot.
    private func presentParkingSpotInformation(parkingSpot: ParkingSpot) {
        debugPrintMessage("Presenting spot found alert view")
        dismissAlertView()
        present(alertView: AlertView(style: .alert)) {
            $0.title = "Spot Found!"
            $0.message = parkingSpot.location + "\n\n" + parkingSpot.spotId
            $0.messageLabel.lineBreakMode = .byWordWrapping
            $0.confirmButton.backgroundColor = .spartanGreen
            $0.confirmButton.setTitle("Go", for: .normal)
            $0.onConfirm {
                self.dismissAlertView()
            }
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
        // speak("All garages are currently full!")
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
}
