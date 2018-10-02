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
    private let permitNumberLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 16.0)
        $0.textAlignment = .center

    }
    private let permitTypeLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 26.0)
        $0.textAlignment = .center
    }
    private let licensePlateLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 16.0)
        $0.textAlignment = .left
    }
    private let expirationDateLabel: UILabel = create(UILabel()) {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 16.0)
        $0.textAlignment = .right
    }

    // MARK: - Card Background
    private let permitTypeBackground: UIView = create(UIView()) {
        $0.clipsToBounds = true
    }
    private let logoImageView: UIImageView = create(UIImageView()) {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "sjsulogo")
    }

    var permit: ParkingPermit! {
        didSet {
            permitTypeLabel.text = permit.type!.rawValue
            licensePlateLabel.text = permit.licensePlate
            expirationDateLabel.text = permit.expirationDate
            permitTypeBackground.backgroundColor = permit.type!.color
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
        let permitNumberLabelWidth:  CGFloat = 130.0
        let permitNumberLabelHeight: CGFloat = 60.0
        permitTypeBackground.addSubview(permitNumberLabel)
        permitNumberLabel.centerXAnchor.constraint(equalTo: permitTypeBackground.centerXAnchor).isActive = true
        permitNumberLabel.centerYAnchor.constraint(equalTo: permitTypeBackground.centerYAnchor).isActive = true
        permitNumberLabel.widthAnchor.constraint(equalToConstant: permitNumberLabelWidth).isActive = true
        permitNumberLabel.heightAnchor.constraint(equalToConstant: permitNumberLabelHeight).isActive = true

        let permitTypeLabelOffset: CGFloat = 10.0
        permitTypeBackground.addSubview(permitTypeLabel)
        permitTypeLabel.topAnchor.constraint(equalTo: permitTypeBackground.topAnchor, constant: permitTypeLabelOffset).isActive = true
        permitTypeLabel.leftAnchor.constraint(equalTo: permitTypeBackground.leftAnchor, constant: -permitTypeLabelOffset).isActive = true
        permitTypeLabel.bottomAnchor.constraint(equalTo: permitTypeBackground.bottomAnchor, constant: -permitTypeLabelOffset).isActive = true
        permitTypeLabel.widthAnchor.constraint(equalTo: permitTypeLabel.heightAnchor).isActive = true
    }
}
