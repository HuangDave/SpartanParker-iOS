//
//  SpotSearchViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class SpotSearchViewController: ViewController {
    private let guestParkingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didSelectGuestParking), for: .touchUpInside)
        return button
    }()

    private let registeredParkingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didSelectRegisteredParking), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spartanGray
    }

    @objc private func didSelectGuestParking(sender: UIButton) {
        sender.isEnabled = false
        defer { sender.isEnabled = true }
    }

    @objc private func didSelectRegisteredParking(sender: UIButton) {
        sender.isEnabled = false
        defer { sender.isEnabled = true }
    }
}
