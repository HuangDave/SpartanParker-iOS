//
//  ParkingPermit.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 10/2/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSDynamoDB

// MARK: -
class ParkingPermit: AWSDynamoDBObjectModel {
    /// For student permit types and prices refer to: http://www.sjsu.edu/parking/permits/student/index.html
    /// For employee permit types refer to: http://www.sjsu.edu/parking/permits/employee/index.html
    enum PermitType: String {
        case student  = "S"
        case employee = "E"
        case office   = "O"
        case reserved = "R"

        var color: UIColor {
            switch self {
            case .student:                      return UIColor.spartanBlue
            case .employee, .office, .reserved: return UIColor.spartanYellow
            }
        }
    }

    var permitId: String?
    var userId: String?
    var licensePlate: String?
    var type: PermitType?
    var expirationDate: String?

    func formattedExpirationDate() -> String {
        // TODO: format and return expirationDate as MM/YYYY
        return ""
    }
}

// MARK: - AWSDynamoDBModeling Implementation
extension ParkingPermit: AWSDynamoDBModeling {
    static func dynamoDBTableName() -> String {
        return "ParkingPermit"
    }

    static func hashKeyAttribute() -> String {
        return "PermitID"
    }
}
