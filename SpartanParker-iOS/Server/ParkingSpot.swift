//
//  ParkingSpot.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/28/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

// MARK: -
class ParkingSpot: DatabaseObject {

    private enum CodingKeys: String, CodingKey {
        case garageId
        case spotId
        case isOccupied
        case spotType
    }

    enum SpotType: String {
        case faculty
        case student
    }

    enum Duration: Int, CaseIterable {
        case oneHour = 1
        case twoHours
        case threeHours
        case fourHours

        var desciption: String {
            return "" // TODO: implement
        }
    }

    private(set) var garageId:   String   = ""
    private(set) var spotId:     String   = ""
    private(set) var isOccupied: Bool     = false
    private(set) var spotType:   SpotType = .student

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        garageId      = try container.decode(String.self, forKey: .garageId)
        spotId        = try container.decode(String.self, forKey: .spotId)
        isOccupied    = try container.decode(Bool.self,   forKey: .isOccupied)
        if let type = SpotType(rawValue: try container.decode(String.self, forKey: .spotType)) {
            spotType = type
        }
    }

    override func serialized() -> JSON {
        var data = super.serialized()
        data[CodingKeys.garageId.rawValue]   = garageId
        data[CodingKeys.spotId.rawValue]     = spotId
        data[CodingKeys.isOccupied.rawValue] = isOccupied
        data[CodingKeys.spotType.rawValue]   = spotType.rawValue
        return data
    }
}

extension ParkingSpot {
    class func searchForVacantSpot(success: (ParkingSpot) -> Void, failure: (Error) -> Void) {
        // TODO: implement
    }

    func attemptToOccupy(forDuration duration: Duration, success: () -> Void, failure: (Error) -> Void) {
        // TODO: implement
    }
}
