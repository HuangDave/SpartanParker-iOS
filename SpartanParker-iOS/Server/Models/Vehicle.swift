//
//  Vehicle.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 11/20/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSCore
import AWSCognitoIdentityProvider
import AWSDynamoDB
import PromiseKit

/// Database object consisting of the vehicles registered license plates, owner,
/// and basic vehicle information.
class Vehicle: DatabaseObject {
    @objc var userId: String!
    @objc var licensePlate: String!
    @objc var make: String?
    @objc var model: String?
    @objc var year: NSNumber?

    // MARK: - AWSDynamoDBModeling Overrides

    override class func dynamoDBTableName() -> String {
        return "Vehicle"
    }

    override class func hashKeyAttribute() -> String {
        return "userId"
    }

    // MARK: - Query

    /// Retreives the vehicle information for a specified userId.
    ///
    /// - Parameters:
    ///     - userId: Owner of the vehicle information to retreive.
    ///
    /// - Returns: Returns the user's vehicles information.
    class func get(userId: String) -> Promise<Vehicle> {
        let query = AWSDynamoDBQueryExpression()
        query.indexName = "userId-index"
        query.keyConditionExpression    = "#userId = :userId"
        query.expressionAttributeNames  = ["#userId": "userId"]
        query.expressionAttributeValues = [":userId": userId]
        return Query<Vehicle>.get(expression: query)
    }
}
