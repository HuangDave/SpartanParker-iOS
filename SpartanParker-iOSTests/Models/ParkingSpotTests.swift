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
        continueAfterFailure = false
        AWSHelper.authenticateUserIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_getVacantSpot() {
        let timeout = 10.0
        let expect  = expectation(description: "Get vacant parking spot")
        var vacantSpot: ParkingSpot?
        _ = ParkingSpot.getVacantSpot()
            .done { spot in
                vacantSpot = spot
                expect.fulfill()
            }
            .catch { error in
                debugPrintMessage(error)
                expect.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertNotNil(vacantSpot, "Should not be nil")
        // XCTAssertEqual(vacantSpot!.spotId , "A1", "Expected: A1, Result: \(String(vacantSpot!.spotId))")
        XCTAssertFalse(vacantSpot!.isAwaitingUser, "Expected: \(false), Result: \(vacantSpot!.isAwaitingUser)")
        XCTAssertFalse(vacantSpot!.isOccupied, "Expected: \(false), Result: \(vacantSpot!.isOccupied)")
        XCTAssertNil(vacantSpot!.occupant, "Should be nil")
    }
}
