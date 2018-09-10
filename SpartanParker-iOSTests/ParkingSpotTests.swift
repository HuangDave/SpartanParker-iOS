//
//  ParkingSpotTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 8/28/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

// swiftlint:disable force_cast force_try
class ParkingSpotTests: XCTestCase {
    let facultySpotDictionary: [String: Any] = [
        "uid": "8735utioefdsuw98",
        "garageId": "ihAU78YUfge",
        "spotId": "asdfi8723",
        "isOccupied": false,
        "spotType": "faculty",
        "createdAt": "0001-01-01T00:00:00Z",
        "updatedAt": "9999-12-31T23:59:59Z"
        ]

    let studentSpotDictionary: [String: Any] = [
        "uid": "8735uasUIdfoefdsuw98",
        "garageId": "ihAU78YadsfUfge",
        "spotId": "asdfisdfaaAS8723",
        "isOccupied": true,
        "spotType": "student",
        "createdAt": "0101-01-01T00:00:00Z",
        "updatedAt": "9009-12-31T23:59:59Z"
        ]

    var facultySpot: ParkingSpot!
    var studentSpot: ParkingSpot!

    override func setUp() {
        super.setUp()

        var data    = try! JSONSerialization.data(withJSONObject: facultySpotDictionary, options: .prettyPrinted)
        facultySpot = try! JSONDecoder().decode(ParkingSpot.self, from: data)
        data        = try! JSONSerialization.data(withJSONObject: studentSpotDictionary, options: .prettyPrinted)
        studentSpot = try! JSONDecoder().decode(ParkingSpot.self, from: data)
    }

    func test_init() {
        XCTAssertEqual(facultySpot.uid,        facultySpotDictionary["uid"]        as! String)
        XCTAssertEqual(facultySpot.garageId,   facultySpotDictionary["garageId"]   as! String)
        XCTAssertEqual(facultySpot.spotId,     facultySpotDictionary["spotId"]     as! String)
        XCTAssertEqual(facultySpot.isOccupied, facultySpotDictionary["isOccupied"] as! Bool)
        XCTAssertEqual(facultySpot.spotType,   ParkingSpot.SpotType.faculty)
        XCTAssertEqual(facultySpot.createdAt,  facultySpotDictionary["createdAt"]  as! String)
        XCTAssertEqual(facultySpot.updatedAt,  facultySpotDictionary["updatedAt"]  as! String)

        XCTAssertEqual(studentSpot.uid,        studentSpotDictionary["uid"]        as! String)
        XCTAssertEqual(studentSpot.garageId,   studentSpotDictionary["garageId"]   as! String)
        XCTAssertEqual(studentSpot.spotId,     studentSpotDictionary["spotId"]     as! String)
        XCTAssertEqual(studentSpot.isOccupied, studentSpotDictionary["isOccupied"] as! Bool)
        XCTAssertEqual(studentSpot.spotType,   ParkingSpot.SpotType.student)
        XCTAssertEqual(studentSpot.createdAt,  studentSpotDictionary["createdAt"]  as! String)
        XCTAssertEqual(studentSpot.updatedAt,  studentSpotDictionary["updatedAt"]  as! String)
    }

    func test_serialized() {
        let facultySpotData = facultySpot.serialized()
        XCTAssertEqual(facultySpotData.count, facultySpotDictionary.count)
        XCTAssertEqual(facultySpotData["uid"]        as! String, facultySpotDictionary["uid"]        as! String)
        XCTAssertEqual(facultySpotData["garageId"]   as! String, facultySpotDictionary["garageId"]   as! String)
        XCTAssertEqual(facultySpotData["spotId"]     as! String, facultySpotDictionary["spotId"]     as! String)
        XCTAssertEqual(facultySpotData["isOccupied"] as! Bool,   facultySpotDictionary["isOccupied"] as! Bool)
        XCTAssertEqual(facultySpotData["spotType"]   as! String, facultySpotDictionary["spotType"]   as! String)
        XCTAssertEqual(facultySpotData["createdAt"]  as! String, facultySpotDictionary["createdAt"]  as! String)
        XCTAssertEqual(facultySpotData["updatedAt"]  as! String, facultySpotDictionary["updatedAt"]  as! String)

        let studentSpotData = studentSpot.serialized()
        XCTAssertEqual(studentSpotData.count, studentSpotDictionary.count)
        XCTAssertEqual(studentSpotData["uid"]        as! String, studentSpotDictionary["uid"]        as! String)
        XCTAssertEqual(studentSpotData["garageId"]   as! String, studentSpotDictionary["garageId"]   as! String)
        XCTAssertEqual(studentSpotData["spotId"]     as! String, studentSpotDictionary["spotId"]     as! String)
        XCTAssertEqual(studentSpotData["isOccupied"] as! Bool,   studentSpotDictionary["isOccupied"] as! Bool)
        XCTAssertEqual(studentSpotData["spotType"]   as! String, studentSpotDictionary["spotType"]   as! String)
        XCTAssertEqual(studentSpotData["createdAt"]  as! String, studentSpotDictionary["createdAt"]  as! String)
        XCTAssertEqual(studentSpotData["updatedAt"]  as! String, studentSpotDictionary["updatedAt"]  as! String)
    }
}
