//
//  PermitViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 10/2/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class PermitViewController: ViewController {
    private var permitCardView: ParkingPermitCardView = ParkingPermitCardView()
    private var permit: ParkingPermit?

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
        navigationController?.title = "Permits"
        fetchPermit()
    }

    private func fetchPermit() {
        permitCardView.permit = permit
    }

    private func purcharsePermit() {

    }
}
