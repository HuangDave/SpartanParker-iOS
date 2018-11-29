//
//  VehicleInformationViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

import AWSDynamoDB

/// The VehicleInformationViewController allows the user to edit their vehicle information.
class VehicleInformationViewController: ViewController {
    let licensePlateField = create(TextField(placeHolder: "License", key: "license")) {
        $0.inputField.autocorrectionType = .no
        $0.inputField.autocapitalizationType = .none
    }
    let vehicleMakeField  = TextField(placeHolder: "Make",  key: "make")
    let vehicleModelField = TextField(placeHolder: "Model", key: "model")
    let vehicleYearField  = create(TextField(placeHolder: "Year", key: "year")) {
        $0.inputField.keyboardType = .numberPad
    }

    private var vehicle: Vehicle?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanLightGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(didSelectSave))
        view.addSubview(licensePlateField)
        view.addSubview(vehicleMakeField)
        view.addSubview(vehicleModelField)
        view.addSubview(vehicleYearField)
        configureConstraints()
        getUserVehicleInformation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.title = "Vehicle"
    }

    private func configureConstraints() {
        let topSpacing:        CGFloat = 32.0
        let verticalSpacing:   CGFloat = 16.0
        let horizontalPadding: CGFloat = 25.0
        licensePlateField.translatesAutoresizingMaskIntoConstraints = false
        licensePlateField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: topSpacing).isActive = true
        licensePlateField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                constant: horizontalPadding).isActive = true
        licensePlateField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                 constant: -horizontalPadding).isActive = true
        licensePlateField.heightAnchor.constraint(equalToConstant: TextField.defaultHeight).isActive = true

        vehicleMakeField.translatesAutoresizingMaskIntoConstraints = false
        vehicleMakeField.topAnchor.constraint(equalTo: licensePlateField.bottomAnchor,
                                              constant: verticalSpacing).isActive = true
        vehicleMakeField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                               constant: horizontalPadding).isActive = true
        vehicleMakeField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                constant: -horizontalPadding).isActive = true
        vehicleMakeField.heightAnchor.constraint(equalToConstant: TextField.defaultHeight).isActive = true

        vehicleModelField.translatesAutoresizingMaskIntoConstraints = false
        vehicleModelField.topAnchor.constraint(equalTo: vehicleMakeField.bottomAnchor,
                                               constant: verticalSpacing).isActive = true
        vehicleModelField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                constant: horizontalPadding).isActive = true
        vehicleModelField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                 constant: -horizontalPadding).isActive = true
        vehicleModelField.heightAnchor.constraint(equalToConstant: TextField.defaultHeight).isActive = true

        vehicleYearField.translatesAutoresizingMaskIntoConstraints = false
        vehicleYearField.topAnchor.constraint(equalTo: vehicleModelField.bottomAnchor,
                                              constant: verticalSpacing).isActive = true
        vehicleYearField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                               constant: horizontalPadding).isActive = true
        vehicleYearField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                constant: -horizontalPadding).isActive = true
        vehicleYearField.heightAnchor.constraint(equalToConstant: TextField.defaultHeight).isActive = true
    }

    /// Gets the user's currently stored vehicle information from DynamoDB.
    private func getUserVehicleInformation() {
        present(alertView: AlertView(style: .alert)) {
            $0.message = "Getting vehicle information."
            $0.confirmButton.backgroundColor = .spartanRed
            $0.confirmButton.setTitle("Back", for: .normal)
            $0.onConfirm {
                self.navigationController?.popViewController(animated: true)
            }
        }
        if let userId = User.currentUser?.username {
            Vehicle.get(userId: userId)
                .done { [weak self] vehicle in
                    self?.dismissAlertView()
                    self?.vehicle = vehicle
                    self?.licensePlateField.text = self?.vehicle?.licensePlate
                    self?.vehicleMakeField.text = self?.vehicle?.make
                    self?.vehicleModelField.text = self?.vehicle?.model
                    self?.vehicleYearField.text = self?.vehicle?.year?.stringValue
                }
                .catch { [weak self] error in
                    self?.dismissAlertView()
                    self?.presentErrorAlert(message: error.localizedDescription, buttonTitle: "Back")
            }
        }
    }

    @objc private func didSelectSave() {
        view.endEditing(true)
        guard let licensePlate = licensePlateField.text,
              let make = vehicleMakeField.text,
              let model = vehicleModelField.text,
              let year = Int(vehicleYearField.text ?? "0")
        else {
            presentErrorAlert(message: "One or more fields are empty or invalid", buttonTitle: "Back")
            return
        }
        if let vehicle = self.vehicle {
            vehicle.licensePlate = licensePlate
            vehicle.make = make
            vehicle.model = model
            vehicle.year = NSNumber(value: year)
            vehicle.save().done {
                self.present(alertView: AlertView(style: .alert), setup: {
                    $0.message = "Saved!"
                    $0.confirmButton.setTitle("OK", for: .normal)
                    $0.confirmButton.backgroundColor = .spartanGreen
                    $0.onConfirm {
                        self.dismissAlertView()
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                }.catch { error in
                    self.presentErrorAlert(message: error.localizedDescription, buttonTitle: "Back")
            }
        } else {
            present(alertView: AlertView(style: .alert)) {
                $0.message = "Unable to save vehicle information"
                $0.confirmButton.setTitle("Back", for: .normal)
                $0.confirmButton.backgroundColor = .spartanRed
                $0.onConfirm {
                    self.dismissAlertView()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
