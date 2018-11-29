//
//  ParkingPermitCardView.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 10/2/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class ParkingPermitCardView: UIView {
    // MARK: - Labels
    let permitUnavailableLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.text = "You do not have a permit!"
        $0.textColor = UIColor.spartanGray
        $0.font = UIFont.boldSystemFont(ofSize: 18.0)
        $0.textAlignment = .center
    }
    let permitNumberLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 16.0)
        $0.textAlignment = .center
    }
    let permitTypeLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 26.0)
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius  = UIView.Theme.cornerRadius / 2.0
    }
    let licensePlateLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 16.0)
        $0.textAlignment = .left
    }
    let expirationDateLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 16.0)
        $0.textAlignment = .right
    }

    // MARK: - Card Background
    let permitTypeBackground: UIView = create(UIView()) {
        $0.clipsToBounds = true
    }
    let logoImageView: UIImageView = create(UIImageView()) {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "sjsu_logo")
        $0.isOpaque = true
        $0.alpha = 0.15
    }

    var permit: ParkingPermit? {
        didSet {
            displayPermitInformation()
        }
    }

    // MARK: -
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not used")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    // MARK: - Constraint Configurations
    private func setupView() {
        backgroundColor     = .white
        layer.masksToBounds = true
        layer.cornerRadius  = UIView.Theme.cornerRadius

        addSubview(permitTypeBackground)
        addSubview(logoImageView)

        setupBackgroundConstraints()
        setupLabelConstraints()
    }

    private func setupBackgroundConstraints() {
        let permitTypeBackgroundHeight: CGFloat = 60.0
        permitTypeBackground.translatesAutoresizingMaskIntoConstraints = false
        permitTypeBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        permitTypeBackground.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        permitTypeBackground.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        permitTypeBackground.heightAnchor.constraint(equalToConstant: permitTypeBackgroundHeight).isActive = true

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: 10.0).isActive = true
        logoImageView.rightAnchor.constraint(equalTo: rightAnchor,
                                             constant: -10.0).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -10.0).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor).isActive = true
    }

    private func setupLabelConstraints() {
        addSubview(permitUnavailableLabel)
        permitUnavailableLabel.translatesAutoresizingMaskIntoConstraints = false
        permitUnavailableLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        permitUnavailableLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let permitNumberLabelWidth:  CGFloat = 130.0
        let permitNumberLabelHeight: CGFloat = 60.0
        permitTypeBackground.addSubview(permitNumberLabel)
        permitNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        permitNumberLabel.centerXAnchor.constraint(equalTo: permitTypeBackground.centerXAnchor).isActive = true
        permitNumberLabel.centerYAnchor.constraint(equalTo: permitTypeBackground.centerYAnchor).isActive = true
        permitNumberLabel.widthAnchor.constraint(equalToConstant: permitNumberLabelWidth).isActive = true
        permitNumberLabel.heightAnchor.constraint(equalToConstant: permitNumberLabelHeight).isActive = true

        let permitTypeLabelOffset: CGFloat = 10.0
        let permitTypeLabelHeight: CGFloat = 40.0
        permitTypeBackground.addSubview(permitTypeLabel)
        permitTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        permitTypeLabel.topAnchor.constraint(equalTo: permitTypeBackground.topAnchor,
                                             constant: permitTypeLabelOffset).isActive = true
        permitTypeLabel.rightAnchor.constraint(equalTo: permitTypeBackground.rightAnchor,
                                               constant: -permitTypeLabelOffset).isActive = true
        permitTypeLabel.bottomAnchor.constraint(equalTo: permitTypeBackground.bottomAnchor,
                                                constant: -permitTypeLabelOffset).isActive = true
        permitTypeLabel.widthAnchor.constraint(equalToConstant: permitTypeLabelHeight).isActive = true

        let bottomLabelOffset:            CGFloat = 25.0
        let bottomLabelHorizontalPadding: CGFloat = 20.0
        let licenseLabelWidth:            CGFloat = 160.0
        let licenseLabelHeight:           CGFloat = 20.0
        addSubview(licensePlateLabel)
        licensePlateLabel.translatesAutoresizingMaskIntoConstraints = false
        licensePlateLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -bottomLabelOffset).isActive = true
        licensePlateLabel.leftAnchor.constraint(equalTo: leftAnchor,
                                                constant: bottomLabelHorizontalPadding).isActive = true
        licensePlateLabel.widthAnchor.constraint(equalToConstant: licenseLabelWidth).isActive = true
        licensePlateLabel.heightAnchor.constraint(equalToConstant: licenseLabelHeight).isActive = true

        addSubview(expirationDateLabel)
        expirationDateLabel.translatesAutoresizingMaskIntoConstraints = false
        expirationDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                    constant: -bottomLabelOffset).isActive = true
        expirationDateLabel.rightAnchor.constraint(equalTo: rightAnchor,
                                                   constant: -bottomLabelHorizontalPadding).isActive = true
        expirationDateLabel.widthAnchor.constraint(equalToConstant: licenseLabelWidth).isActive = true
        expirationDateLabel.heightAnchor.constraint(equalToConstant: licenseLabelHeight).isActive = true
    }
}

// MARK: - Label Accessors
extension ParkingPermitCardView {
    var unavailableText: String? { return permitUnavailableLabel.text }
    var permitNumber:    String? { return permitNumberLabel.text }
    var permitType:      String? { return permitTypeLabel.text }
    var licensePlate:    String? { return licensePlateLabel.text }
    var expirationDate:  String? { return expirationDateLabel.text }
}

// MARK: - Displaying Permit Information
extension ParkingPermitCardView {
    private func displayPermitInformation() {
        guard let permit = self.permit else {
            displayPermitUnavailable()
            return
        }
        permitUnavailableLabel.isHidden = true
        permitNumberLabel.isHidden   = false
        permitTypeLabel.isHidden     = false
        licensePlateLabel.isHidden   = false
        expirationDateLabel.isHidden = false
        permitNumberLabel.text = permit.permitId
        permitTypeLabel.text = "S"
        licensePlateLabel.text = permit.licensePlate
        expirationDateLabel.text = "Exp: \(permit.formatedExpirationDate)"
        permitTypeBackground.backgroundColor = .spartanYellow
    }

    private func displayPermitUnavailable() {
        permitUnavailableLabel.isHidden = false
        permitNumberLabel.isHidden   = true
        permitTypeLabel.isHidden     = true
        licensePlateLabel.isHidden   = true
        expirationDateLabel.isHidden = true
        permitTypeBackground.backgroundColor = .lightGray
    }
}
