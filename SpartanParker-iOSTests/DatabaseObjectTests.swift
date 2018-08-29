//
//  DatabaseObjectTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

class DatabaseObjectTests: XCTestCase {
    
    let objectDictionary: [String: Any] = [
        "uid": "8735utioefdsuw98",
        "createdAt": "0001-01-01T00:00:00Z",
        "updatedAt": "9999-12-31T23:59:59Z"
    ]
    
    var uid:       String { return objectDictionary["uid"]       as! String }
    var createdAt: String { return objectDictionary["createdAt"] as! String }
    var updatedAt: String { return objectDictionary["updatedAt"] as! String }
    
    var object: DatabaseObject!
    
    override func setUp() {
        super.setUp()
        let data = try! JSONSerialization.data(withJSONObject: objectDictionary, options: .prettyPrinted)
        object   = try! JSONDecoder().decode(DatabaseObject.self, from: data)
    }
    
    func test_init() {
        XCTAssertEqual(object.uid,       uid)
        XCTAssertEqual(object.createdAt, createdAt)
        XCTAssertEqual(object.updatedAt, updatedAt)
    }
    
    func test_serialized() {
        let data = object.serialized()
        XCTAssertEqual(data["uid"]       as? String, uid)
        XCTAssertEqual(data["createdAt"] as? String, createdAt)
        XCTAssertEqual(data["updatedAt"] as? String, updatedAt)
    }
}
