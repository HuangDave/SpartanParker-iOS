//
//  UserTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 8/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

// swiftlint:disable force_cast force_try
/*
class UserTests: XCTestCase {
    let userDictionary: [String: Any] = [
        "uid": "8735utioefdsuw98",
        "fullName": [
            "first": "Johny",
            "last": "Appleseed"
        ],
        "email": "johnyappleseed@test.com",
        "password": "sadg89auyefhp9uios",
        "createdAt": "0001-01-01T00:00:00Z",
        "updatedAt": "9999-12-31T23:59:59Z"
        ]

    var fullName:  [String: String] { return userDictionary["fullName"] as! [String: String] }

    var uid:       String { return userDictionary["uid"]       as! String }
    var firstName: String { return fullName["first"]!                     }
    var lastName:  String { return fullName["last"]!                      }
    var email:     String { return userDictionary["email"]     as! String }
    var password:  String { return userDictionary["password"]  as! String }
    var createdAt: String { return userDictionary["createdAt"] as! String }
    var updatedAt: String { return userDictionary["updatedAt"] as! String }

    var user: User!

    override func setUp() {
        super.setUp()
        let data = try! JSONSerialization.data(withJSONObject: userDictionary, options: .prettyPrinted)
        user     = try! JSONDecoder().decode(User.self, from: data)
    }

    func test_init() {
        XCTAssertEqual(user.uid,            uid)
        XCTAssertEqual(user.fullName.first, firstName)
        XCTAssertEqual(user.fullName.last,  lastName)
        XCTAssertEqual(user.email,          email)
        XCTAssertEqual(user.password,       password)
        XCTAssertEqual(user.createdAt,      createdAt)
        XCTAssertEqual(user.updatedAt,      updatedAt)
    }

    func test_serialized() {
        let data = user.serialized()
        let fullName = data["fullName"] as! [String : String]
        XCTAssertEqual(data.count, userDictionary.count)
        XCTAssertEqual(fullName["first"], firstName)
        XCTAssertEqual(fullName["last"],  lastName)
        XCTAssertEqual(data["uid"]       as? String, uid)
        XCTAssertEqual(data["email"]     as? String, email)
        XCTAssertEqual(data["password"]  as? String, password)
        XCTAssertEqual(data["createdAt"] as? String, createdAt)
        XCTAssertEqual(data["updatedAt"] as? String, updatedAt)
    }
}
*/
