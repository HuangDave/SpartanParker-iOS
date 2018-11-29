//
//  VehicleTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 11/26/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

import AWSCore
import AWSDynamoDB

@testable import SpartanParker_iOS

class VehicleTests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        AWSHelper.authenticateUserIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_get() {
        let timeout = 10.0
        let expect  = expectation(description: "Get vacant parking spot")
        let userId = User.currentUser!.username!
        var vehicle: Vehicle?
        _ = Vehicle.get(userId: userId)
            .done { result in
                vehicle = result
                debugPrintMessage(result)
                expect.fulfill()
            }
            .catch { error in
                debugPrintMessage(error)
                expect.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertNotNil(vehicle, "Vehicle not be nil")
    }
}
