//
//  ParkingSpot.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/28/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

import AWSCore
import AWSDynamoDB
import PromiseKit

// MARK: -
final class ParkingSpot: AWSDynamoDBObjectModel {
    enum Duration: UInt, CaseIterable {
        case oneHour = 1
        case twoHours
        case threeHours
        case fourHours
    }

    enum FetchError: Error {
        case noVacantSpot
        case other
    }

    @objc private(set) var spotId: String!
    @objc private(set) var garageId: String!
    @objc private(set) var location: String!
    @objc private(set) var floor: NSNumber!
    @objc private(set) var spotType: String!
    @objc private(set) var isAwaitingUser: Bool = false
    @objc private(set) var isOccupied: Bool = false
    @objc private(set) var occupant: String?
    @objc private(set) var duration: NSNumber!
    @objc private(set) var startTime: Date?
    @objc private(set) var endTime: Date?

    /// Retreives a vacant parking spot entry.
    ///
    /// - Returns: Returns a vacant parking spot if one is found.
    class func getVacantSpot() -> Promise<ParkingSpot> {
        // TODO: should use query instead of scan when searching through a larger amount of spots
        let scan = AWSDynamoDBScanExpression()
        scan.limit = 10
        scan.filterExpression = "isOccupied = :isOccupied AND isAwaitingUser = :isAwaitingUser"
        scan.expressionAttributeValues = [
            ":isOccupied":     false,
            ":isAwaitingUser": false
        ]
        return Promise { promise in
            AWSDynamoDBObjectMapper.default()
                .scan(ParkingSpot.self, expression: scan)
                .continueWith { result -> Any? in
                    if let parkingSpots = result.result?.items as? [ParkingSpot] {
                        if !(parkingSpots.isEmpty), let vacantSpot = parkingSpots.first {
                            debugPrintMessage("ParkingSpot:getVacantSpot: Found Vacant Spot - \(vacantSpot)")
                            promise.fulfill(vacantSpot)
                        } else {
                            debugPrintMessage("No vacant spots found!")
                            promise.reject(FetchError.noVacantSpot)
                        }
                    } else {
                        promise.reject(FetchError.other)
                    }
                    return nil
            }
        }
    }

    func occupy(duration: Duration) -> Promise<ParkingSpot> {
        return Promise { promise in
            // TODO: implement
        }
    }
}

// MARK: - AWSDynamoDBModeling Implementation
extension ParkingSpot: AWSDynamoDBModeling {
    class func dynamoDBTableName() -> String {
        return "ParkingSpot"
    }

    class func hashKeyAttribute() -> String {
        return "spotId"
    }
}
