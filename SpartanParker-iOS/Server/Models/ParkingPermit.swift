//
//  ParkingPermit.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 10/2/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSDynamoDB

// MARK: -
class ParkingPermit: AWSDynamoDBObjectModel, AWSDynamoDBModeling {

    /// For student permit types and prices refer to:
    ///     http://www.sjsu.edu/parking/permits/student/index.html
    /// For employee permit types refer to:
    ///     http://www.sjsu.edu/parking/permits/employee/index.html
    enum PermitType: String {
        case student
        case employee
        case office
        case reserved

        var color: UIColor {
            switch self {
            case .student:                      return UIColor.spartanBlue
            case .employee, .office, .reserved: return UIColor.spartanYellow
            }
        }

        var code: String {
            switch self {
            case .student:  return "S"
            case .employee: return "E"
            case .office:   return "O"
            case .reserved: return "R"
            }
        }
    }

    class func dynamoDBTableName() -> String {
        return "ParkingPermit"
    }

    class func hashKeyAttribute() -> String {
        return "permitId"
    }

    @objc var permitId:       String!
    @objc var userId:         String!
    @objc var licensePlate:   String!
    @objc var vehicleId:      String!
    @objc var type:           String!
    @objc var expirationDate: String!

    /// Expriation date in the following format: MM/YYYY
    var formatedExpirationDate: String {
        return ""
    }
}
