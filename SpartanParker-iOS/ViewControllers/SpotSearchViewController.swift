//
//  SpotSearchViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

// MARK: -
class SpotSearchViewController: ViewController {
    private let guestParkingButton: OptionButton = create(OptionButton()) {
        $0.setTitle("Guest Parking", for: .normal)
        $0.addTarget(self, action: #selector(didSelectGuestParking), for: .touchUpInside)
    }

    private let registeredParkingButton: OptionButton = create(OptionButton()) {
        $0.setTitle("Registered Parking", for: .normal)
        $0.addTarget(self, action: #selector(didSelectRegisteredParking), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanLightGray

        let stackView = UIStackView(arrangedSubviews: [guestParkingButton,
                                                       registeredParkingButton])
        stackView.axis         = .horizontal
        stackView.alignment    = .fill
        stackView.distribution = .fillEqually
        stackView.spacing      = 20.0
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                        constant: 20.0).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                         constant: -20.0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "Search"
    }

    @objc private func didSelectGuestParking(sender: UIButton) {
        sender.isEnabled = false
        defer { sender.isEnabled = true }
        presentSearchingAlert()
    }

    @objc private func didSelectRegisteredParking(sender: UIButton) {
        sender.isEnabled = false
        defer { sender.isEnabled = true }
        presentSearchingAlert()
    }
}

// MARK: - Spot Search Alerts
extension SpotSearchViewController {
    private func presentSearchingAlert() {
        present(alertView: AlertView(style: .alert)) {
            $0.title = "Searching"
            $0.message = "Just a moment..."
            $0.confirmButton.setTitle("CANCEL", for: .normal)
            $0.confirmButton.backgroundColor = .spartanRed
            $0.onConfirm {
                self.dismissAlertView()
                // TODO: cancel search request
                self.presentSpotNotFoundAlert()
            }
        }
    }

    private func presentSpotFoundAlert(spot: ParkingSpot) {
        present(alertView: AlertView(style: .alert)) {
            $0.title = "Spot Found"
            $0.message = "" // TODO: set spot information
            $0.confirmButton.setTitle("GO", for: .normal)
            $0.onConfirm {
                self.dismissAlertView()
                // TODO: add QR scan for guest parking
                // TODO: add payment process for registered parking
            }
        }
    }

    private func presentSpotNotFoundAlert() {
        present(alertView: AlertView(style: .confirmation)) {
            $0.title = "No Spots Available"
            $0.message = "SORRY! All garages are currently full."
            $0.cancelButton?.setTitle("CANCEL", for: .normal)
            $0.confirmButton.setTitle("TRY AGAIN", for: .normal)
            $0.onCancel { // cancel...
                self.dismissAlertView()
            }
            $0.onConfirm { // try again...
                self.dismissAlertView()
                // TODO: refresh spot search
                self.presentSearchingAlert()
            }
        }
    }
}
