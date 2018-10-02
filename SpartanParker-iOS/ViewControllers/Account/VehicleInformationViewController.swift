//
//  VehicleInformationViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

// MARK: -
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanLightGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(didSelectSave))
        licensePlateField.delegate = self
        vehicleMakeField.delegate  = self
        vehicleModelField.delegate = self
        vehicleYearField.delegate  = self

        view.addSubview(licensePlateField)
        view.addSubview(vehicleMakeField)
        view.addSubview(vehicleModelField)
        view.addSubview(vehicleYearField)

        configureConstraints()
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
}

// MARK: -
extension VehicleInformationViewController: UITextFieldDelegate {
}

// MARK: -
extension VehicleInformationViewController: EditingController {
    @objc func didSelectSave() {
        presentEditConfirmationAlert { cancelled in
            guard cancelled != true else { return }
            // TODO: update vehicle information
            //       present alert for success / error
            //       if success pop to Account
            self.presentSavedAlert { // REMOVEME: temp
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
