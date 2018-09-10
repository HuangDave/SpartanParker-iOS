//
//  FullNameTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 8/29/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

class FullNameTests: XCTestCase {
    func test_init() {
        let first = "Johny"
        let last  = "Appleseed"
        let fullName = User.FullName(first: first, last: last)
        XCTAssertEqual(fullName.first, first)
        XCTAssertEqual(fullName.last,  last)
    }
}
