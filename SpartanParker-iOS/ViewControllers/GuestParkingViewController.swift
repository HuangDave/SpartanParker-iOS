//
//  GuestParkingViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/11/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class GuestParkingViewController: ViewController {
    private var durationButtons: [OptionButton]!
    private var parkingSpot: ParkingSpot!

    override func viewDidLoad() {
        super.viewDidLoad()
        durationButtons = [OptionButton]()
        ParkingSpot.Duration.allCases.forEach {
            let tag = $0.rawValue
            let description = $0.desciption
            durationButtons.append(create(OptionButton(), setup: {
                $0.setTitle(description, for: .normal)
                $0.tag = tag
            }))
        }
    }

    private func userDidSelectDuration(sender: OptionButton) {
        guard let duration = ParkingSpot.Duration(rawValue: sender.tag) else { return }
        parkingSpot.attemptToOccupy(forDuration: duration, success: {

        }, failure: { error in
            debugPrintMessage(error)
        })
    }
}
