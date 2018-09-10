//
//  AlertViewTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 8/27/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

class AlertViewTests: XCTestCase {
    var alertView: AlertView!

    func test_init() {

        alertView = AlertView(style: .alert)
        XCTAssertNil(alertView.cancelButton)

        alertView = AlertView(style: .confirmation)
        XCTAssertNotNil(alertView.cancelButton)
    }

    func test_setTitle() {
        let expectedTitle = "Exptected Test Title"

        alertView = AlertView(style: .alert)
        alertView.title = expectedTitle
        XCTAssertEqual(alertView.title, expectedTitle)
        XCTAssertEqual(alertView.titleLabel.text, expectedTitle)

        alertView = AlertView(style: .confirmation)
        alertView.title = expectedTitle
        XCTAssertEqual(alertView.title, expectedTitle)
        XCTAssertEqual(alertView.titleLabel.text, expectedTitle)
    }

    func test_setDescription() {
        let expectedDescription = "Exptected Test Description that sould be set!"

        alertView = AlertView(style: .alert)
        alertView.message = expectedDescription
        XCTAssertEqual(alertView.message, expectedDescription)
        XCTAssertEqual(alertView.messageLabel.text, expectedDescription)

        alertView = AlertView(style: .confirmation)
        alertView.message = expectedDescription
        XCTAssertEqual(alertView.message, expectedDescription)
        XCTAssertEqual(alertView.messageLabel.text, expectedDescription)
    }

    func test_didSelectCancel() {
        var cancelled = false
        alertView = AlertView(style: .alert)
        alertView.onCancel {
            cancelled = true
        }
        alertView.didSelectCancel()
        XCTAssertFalse(cancelled)

        alertView = AlertView(style: .confirmation)
        alertView.onCancel {
            cancelled = true
        }
        alertView.didSelectCancel()
        XCTAssertTrue(cancelled)
    }

    func test_didSelectConfirm() {
        var confirmed = false
        alertView = AlertView(style: .alert)
        alertView.onConfirm {
            confirmed = true
        }
        alertView.didSelectConfirm()
        XCTAssertTrue(confirmed)

        confirmed = false
        alertView = AlertView(style: .confirmation)
        alertView.onConfirm {
            confirmed = true
        }
        alertView.didSelectConfirm()
        XCTAssertTrue(confirmed)
    }
}
