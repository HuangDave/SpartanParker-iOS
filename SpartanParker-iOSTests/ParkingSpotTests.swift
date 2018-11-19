//
//  ParkingSpotTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 8/28/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

import AWSCore
import AWSDynamoDB

@testable import SpartanParker_iOS

class ParkingSpotTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let email = TestUser.email
        let password = TestUser.password
        AWSManager.shared.registerCognito()
        AWSManager.Cognito.userPool.currentUser()?
            .getSession(email, password: password, validationData: nil)
            .waitUntilFinished()
    }

    override func tearDown() {
        User.logout()
        super.tearDown()
    }

    func test_getVacantSpot() {
        let expect = expectation(description: "Get vacant parking spot")
        var vacantSpot: ParkingSpot?
        ParkingSpot.getVacantSpot(success: { spot in
            vacantSpot = spot
            expect.fulfill()
        }, failure: { error in

        })
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(vacantSpot)
        XCTAssertTrue(vacantSpot?.SpotID == "A1")
    }
}
