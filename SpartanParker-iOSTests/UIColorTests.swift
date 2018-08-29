//
//  UIColorTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

class UIColorTests: XCTestCase {
    
    func test_initWithHexValue() {
        
        let color  = UIColor(hex: 0xF00FFF)
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        XCTAssertTrue(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        XCTAssertEqual(red,   0xF0 / 255.0)
        XCTAssertEqual(green, 0x0F / 255.0)
        XCTAssertEqual(blue,  0xFF / 255.0)
        XCTAssertEqual(alpha, 1.0)
    }
}
