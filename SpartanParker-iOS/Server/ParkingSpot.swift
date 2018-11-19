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

// MARK: -
class ParkingSpot: AWSDynamoDBObjectModel {
    enum Duration: UInt, CaseIterable {
        case oneHour = 1
        case twoHours
        case threeHours
        case fourHours
    }

    enum SpotType: String {
        case faculty
        case student
    }

    enum ParkingSpotError {
        case noVacantSpot
        case other
    }

    //@objc var garageId: String?
    @objc var spotID:    String!
    @objc var location:  String!
    @objc var spotType:  String!
    @objc var studentID: String?
    @objc var vacant:    Bool = true

    // MARK:

    class func getVacantSpot(success: @escaping (ParkingSpot) -> Void,
                             failure: @escaping (ParkingSpotError) -> Void) {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        AWSDynamoDBObjectMapper.default()
            .scan(ParkingSpot.self, expression: scanExpression)
            .continueWith { result -> Any? in
                if let parkingSpots = result.result?.items as? [ParkingSpot] {
                    if !(parkingSpots.isEmpty), let vacantSpot = parkingSpots.first {
                        success(vacantSpot)
                    } else {
                        failure(ParkingSpotError.noVacantSpot)
                    }
                } else {
                    failure(ParkingSpotError.other)
                }
                return nil
        }
    }

    // MARK:

    func occupy(duration: Duration,
                success: () -> Void,
                failure: (Error) -> Void) {
        // TODO: implement
    }
}

// MARK: - AWSDynamoDBModeling
extension ParkingSpot: AWSDynamoDBModeling {
    class func dynamoDBTableName() -> String {
        return "VacantSpotDB"
    }

    class func hashKeyAttribute() -> String {
        return "SpotId"
    }

    class func rangeKeyAttribute() -> String {
        return ""
    }
}
