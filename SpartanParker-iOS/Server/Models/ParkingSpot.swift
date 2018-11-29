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

class ParkingSpot: DatabaseObject {
    enum Duration: UInt, CaseIterable {
        case oneHour = 1
        case twoHours
        case threeHours
        case fourHours

        var description: String { return String("\(rawValue) Hour(s)")}

        var price: NSDecimalNumber {
            switch self {
            case .oneHour:    return NSDecimalNumber(decimal: 2.00)
            case .twoHours:   return NSDecimalNumber(decimal: 3.00)
            case .threeHours: return NSDecimalNumber(decimal: 4.00)
            case .fourHours:  return NSDecimalNumber(decimal: 5.00)
            }
        }
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
    @objc private(set) var startTime: String?
    @objc private(set) var endTime: String?

    var formattedLocation: String {
        return location + "\n\n" + spotId
    }

    // MARK: - AWSDynamoDBModeling Overrides

    override class func dynamoDBTableName() -> String {
        return "ParkingSpot"
    }

    override class func hashKeyAttribute() -> String {
        return "spotId"
    }

    // MARK: -

    /// Retreives a vacant parking spot entry.
    ///
    /// - Returns: Returns a vacant parking spot if one is found.
    class func getVacantSpot() -> Promise<ParkingSpot> {
        let scan = AWSDynamoDBScanExpression()
        // scan.limit = 10
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
                            promise.reject(Query.FetchError.notFound)
                        }
                    } else {
                        promise.reject(Query.FetchError.other)
                    }
                    return nil
            }
        }
    }

    func occupy(occupant: String) -> Promise<Void> {
        isOccupied = true
        isAwaitingUser = false
        self.occupant = occupant
        return save()
    }
    /// Sets the parking spot to occupied and saves the occupant, duration, and the start and end times.
    ///
    /// - Parameters:
    ///     - occupant: Id of the occupant
    ///     - duration: Amount of the time in hours
    /// - Returns:
    func occupy(occupant: String, duration: Duration) -> Promise<Void> {
        let currentTime = Date()
        isOccupied = true
        isAwaitingUser = false
        self.occupant = occupant
        self.duration = NSNumber(value: duration.rawValue)
        startTime = currentTime.description
        endTime = currentTime.addingTimeInterval(TimeInterval(duration.rawValue * 60 * 60)).description
        return save()
    }
    func unOccupy() -> Promise<Void> {
        isOccupied = false
        occupant = nil
        return save()
    }
}
