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

    @objc private(set) var transactionId: String!
    @objc var userId: String!
    @objc var type: String!
    @objc var duration: NSNumber?
    @objc var amount: NSNumber!
    @objc var createdAt: String!

    // MARK: - AWSDynamoDBModeling Overrides

    override class func dynamoDBTableName() -> String {
        return "Transaction"
    }

    override class func hashKeyAttribute() -> String {
        return "transactionId"
    }

    // MARK: -

    required init!(coder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    init(type: TransactionType) {
        super.init()
        transactionId = UUID().uuidString
        userId = User.currentUser!.username!
        self.type = type.rawValue
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
        return Query<Transaction>.get(expression: query)
    }
}
