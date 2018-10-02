//
//  ParkingPermitCardViewTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 10/9/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

class ParkingPermitCardViewTests: XCTestCase {
    var permit: ParkingPermit!
    var cardView: ParkingPermitCardView!

    override func setUp() {
        super.setUp()
        cardView = ParkingPermitCardView()
        permit = ParkingPermit()
        permit.licensePlate = "123abc4"
        permit.type = .student
        permit.permitId = "123456"
        permit.expirationDate = "Exp. 12/2020"
    }

    func test_setPermit() {
        cardView.permit = permit

        XCTAssertTrue(cardView.permitUnavailableLabel.isHidden)
        XCTAssertFalse(cardView.permitNumberLabel.isHidden)
        XCTAssertFalse(cardView.licensePlateLabel.isHidden)
        XCTAssertFalse(cardView.permitTypeLabel.isHidden)
        XCTAssertFalse(cardView.expirationDateLabel.isHidden)

        XCTAssertEqual(cardView.permitNumber, permit.permitId)
        XCTAssertEqual(cardView.licensePlate, permit.licensePlate)
        XCTAssertEqual(cardView.permitType, permit.type!.rawValue)
        XCTAssertEqual(cardView.expirationDate, permit.expirationDate)
    }

    func test_setNilPermit() {
        cardView.permit = nil

        XCTAssertFalse(cardView.permitUnavailableLabel.isHidden)
        XCTAssertTrue(cardView.permitNumberLabel.isHidden)
        XCTAssertTrue(cardView.licensePlateLabel.isHidden)
        XCTAssertTrue(cardView.permitTypeLabel.isHidden)
        XCTAssertTrue(cardView.expirationDateLabel.isHidden)

        XCTAssertEqual(cardView.permitUnavailableLabel.text, "You do not have a permit!")
        XCTAssertEqual(cardView.permitNumber, nil)
        XCTAssertEqual(cardView.licensePlate, nil)
        XCTAssertEqual(cardView.permitType, nil)
        XCTAssertEqual(cardView.expirationDate, nil)
    }
}
