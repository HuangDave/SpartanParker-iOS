//
//  DurationPickerView.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 11/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class DurationPickerView: AlertView {
    let pickerView: UIPickerView = create(UIPickerView()) {
        $0.backgroundColor = .white
    }
    private(set) var duration: ParkingSpot.Duration = .oneHour

    // MARK: -

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(style: .confirmation)
    }

    override func commonInit() {
        super.commonInit()
        pickerView.dataSource = self
        pickerView.delegate = self
        messageLabel.isUserInteractionEnabled = true
        messageLabel.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: messageLabel.topAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: messageLabel.leftAnchor,
                                         constant: 20.0).isActive = true
        pickerView.rightAnchor.constraint(equalTo: messageLabel.rightAnchor,
                                          constant: -20.0).isActive = true
    }
}

extension DurationPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return 1
        }
        return ParkingSpot.Duration.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return "Hours"
        }
        return String(ParkingSpot.Duration.allCases[row].rawValue)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        duration = ParkingSpot.Duration.allCases[row]
    }
}
