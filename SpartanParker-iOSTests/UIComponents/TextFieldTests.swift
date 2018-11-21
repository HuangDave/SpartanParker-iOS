//
//  TextFieldTests.swift
//  SpartanParker-iOSUITests
//
//  Created by DAVID HUANG on 8/23/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

class TextFieldTests: XCTestCase {
    var textField: TextField!

    override func setUp() {
        super.setUp()
    }

    func test_init() {
        let placeHolder = "Random placeholder test"
        let key = "test"
        let textField = TextField(placeHolder: placeHolder, key: key)

        XCTAssertEqual(textField.frame.height, TextField.defaultHeight)
        XCTAssertEqual(textField.placeHolderText, placeHolder)
        XCTAssertEqual(textField.key, key)
        XCTAssertEqual(textField.layer.cornerRadius, 14.0)
        XCTAssertEqual(textField.inputField.borderStyle, .none)
        XCTAssertEqual(textField.inputField.textColor, .black)
        XCTAssertEqual(textField.inputField.font, UIFont.descriptionFont)
        XCTAssertEqual(textField.inputField.clearButtonMode, .whileEditing)
    }

    func test_placeHolder() {
        let placeHolder = "Some placeholder here"
        let textField = TextField()
        textField.placeHolderText = placeHolder
        XCTAssertEqual(textField.placeHolderText, placeHolder)
    }
}
