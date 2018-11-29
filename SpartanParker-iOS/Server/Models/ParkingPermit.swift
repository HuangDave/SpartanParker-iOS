//
//  ParkingPermit.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 10/2/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSCognitoIdentityProvider
import AWSDynamoDB
import PromiseKit

class ParkingPermit: DatabaseObject {
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

        var price: NSDecimalNumber {
            switch self {
            case .student: return NSDecimalNumber(decimal: 200.00)
            default: return NSDecimalNumber(decimal: 0.0)
            }
        }
    }
    // MARK: -
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

    // MARK: - AWSDynamoDBModeling Overrides

    class override func dynamoDBTableName() -> String {
        return "ParkingPermit"
    }

    class override func hashKeyAttribute() -> String {
        return "permitId"
    }

    // MARK: - Query

    /// Queries a user's parking permit.
    ///
    /// - Parameters:
    ///     - userId: Id of the user.
    ///
    /// - Returns: Returns a Promise with the user's permit or a FetchError.
    class func by(userId: String) -> Promise<ParkingPermit> {
        let query = AWSDynamoDBQueryExpression()
        query.indexName                = "userId-index"
        query.keyConditionExpression   = "#userId = :userId"
        query.expressionAttributeNames = ["#userId": "userId"]
        query.limit                    = 1
        return Query<ParkingPermit>.get(expression: query)
    }
}
