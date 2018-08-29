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
    
    private enum AttributeKeys: String, CodingKey {
        case garageId
        case spotId
        case isOccupied
        case spotType
    }
    
    enum SpotType: String {
        case faculty
        case student
    }
    
    private(set) var garageId:   String   = ""
    private(set) var spotId:     String   = ""
    private(set) var isOccupied: Bool     = false
    private(set) var spotType:   SpotType = .student
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: AttributeKeys.self)
        garageId      = try container.decode(String.self, forKey: .garageId)
        spotId        = try container.decode(String.self, forKey: .spotId)
        isOccupied    = try container.decode(Bool.self,   forKey: .isOccupied)
        if let type = SpotType(rawValue: try container.decode(String.self, forKey: .spotType)) {
            spotType = type
        }
    }
    
    override func serialized() -> [String : Any] {
        var data = super.serialized()
        data[AttributeKeys.garageId.rawValue]   = garageId
        data[AttributeKeys.spotId.rawValue]     = spotId
        data[AttributeKeys.isOccupied.rawValue] = isOccupied
        data[AttributeKeys.spotType.rawValue]   = spotType.rawValue
        return data
    }
}

// MARK: -
extension ParkingSpot {
    
    class func searchForVacantSpot() -> ParkingSpot? {
        return nil
    }
}