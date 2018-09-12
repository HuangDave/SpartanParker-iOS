//
//  SegmentedControllerTests.swift
//  SpartanParker-iOSTests
//
//  Created by DAVID HUANG on 8/23/18.
//  Copyright © 2018 David. All rights reserved.
//

import XCTest

@testable import SpartanParker_iOS

class SegmentedControllerTests: XCTestCase {
    let items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    let totalSegmentCount = 4

    var segmentedController: SegmentedController!

    override func setUp() {
        super.setUp()
        segmentedController = SegmentedController(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func test_highlightColor() {
        let highlightColor = UIColor.blue
        segmentedController.highlightColor = highlightColor
        XCTAssertEqual(segmentedController.highlightIndicator.backgroundColor, highlightColor)
        XCTAssertEqual(segmentedController.highlightColor, highlightColor)
    }

    func test_updateView() {
        segmentedController.titles = items
        segmentedController.updateView()
        XCTAssertTrue(segmentedController.segments.count == totalSegmentCount)
        XCTAssertTrue(segmentedController.segments[0].titleLabel?.text == "Item 1")
        XCTAssertTrue(segmentedController.segments[1].titleLabel?.text == "Item 2")
        XCTAssertTrue(segmentedController.segments[2].titleLabel?.text == "Item 3")
        XCTAssertTrue(segmentedController.segments[3].titleLabel?.text == "Item 4")
    }

    func test_invalidateView() {
        segmentedController.titles = items
        segmentedController.updateView()
        XCTAssertTrue(segmentedController.segments.count == totalSegmentCount)
        segmentedController.invalidateView()
        XCTAssertTrue(segmentedController.segments.isEmpty)
    }

    func test_userDidTapSegment() {
        class SpySegmentedController: SegmentedControllerDelegate {
            var tappedSegmentIndex: Int?
            func segmentedController(_ segmentedController: SegmentedController, didSelectSegmentAtIndex index: Int) {
                tappedSegmentIndex = index
            }
        }
        let spySegmentedController = SpySegmentedController()
        segmentedController.delegate = spySegmentedController
        segmentedController.titles = items
        segmentedController.updateView()
        XCTAssertNil(spySegmentedController.tappedSegmentIndex)
        segmentedController.userDidTapSegment(segmentedController.segments[0])
        XCTAssertEqual(spySegmentedController.tappedSegmentIndex, 0)
        segmentedController.userDidTapSegment(segmentedController.segments[1])
        XCTAssertEqual(spySegmentedController.tappedSegmentIndex, 1)
        segmentedController.userDidTapSegment(segmentedController.segments[2])
        XCTAssertEqual(spySegmentedController.tappedSegmentIndex, 2)
        segmentedController.userDidTapSegment(segmentedController.segments[3])
        XCTAssertEqual(spySegmentedController.tappedSegmentIndex, 3)
    }
}
