//
//  Transaction.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 11/23/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSCognitoIdentityProvider
import AWSDynamoDB
import PromiseKit

class Transaction: DatabaseObject {
    enum TransactionType: String {
        case parking
        case permitPurchase
    }

    @objc var transactionId: String!
    @objc var userId: String!
    @objc var type: String!
    @objc var duration: NSNumber?
    @objc var amount: NSNumber!
    @objc var createdAt: String!

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = dateFormatter.date(from: createdAt)
        let components = NSCalendar.current.dateComponents([.month, .day, .year, .hour, .minute],
                                                           from: date!)
        let hour       = components.hour!
        let minutes    = components.minute!
        let timeString = "\(hour % 12):\(minutes < 10 ? "0" : "")\(minutes) \(hour > 12 ? "PM" : "AM")"
        return "\((components.month!))/\(components.day!)/\(components.year!) \(timeString)"
    }

    // MARK: - AWSDynamoDBModeling Overrides

    override class func dynamoDBTableName() -> String {
        return "Transaction"
    }

    override class func hashKeyAttribute() -> String {
        return "transactionId"
    }

    // MARK: Query

    /// Queries all transaction records for the specified userId.
    ///
    /// - Parameters:
    ///     - userId: User's id.
    ///
    /// - Returns: Returns a Promise with all transaction records.
    class func getAll(userId: String) -> Promise<[Transaction]> {
        let query = AWSDynamoDBQueryExpression()
        query.indexName = "userId-index"
        query.keyConditionExpression    = "#userId = :userId"
        query.expressionAttributeNames  = ["#userId": "userId"]
        query.expressionAttributeValues = [":userId": userId]
        return Query<Transaction>.get(expression: query)
    }
}
