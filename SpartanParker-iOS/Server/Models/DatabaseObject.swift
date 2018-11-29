//
//  DatabaseObject.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 11/22/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSDynamoDB
import PromiseKit

/// Base DynamobDB object class.
class DatabaseObject: AWSDynamoDBObjectModel, AWSDynamoDBModeling {

    // MARK: - AWSDynamoDBModeling Implementation

    class func dynamoDBTableName() -> String {
        fatalError("Should be overriden to provide table name")
    }

    class func hashKeyAttribute() -> String {
        fatalError("Should be overriden to provide hash key attribute")
    }
    /// Saves or updates the database object.
    ///
    /// - Returns: Returns a Promise containing an error if an error occurred while
    ///            attempting to sava the item.
    func save() -> Promise<Void> {
        return Promise { promise in
            AWSDynamoDBObjectMapper.default()
                .save(self)
                .continueWith { task -> Any? in
                    promise.resolve(task.error)
                    return nil
                }
        }
    }
    /// Removes the database object from the database table.
    ///
    /// - Returns: Returns a Promise containing an error if an error occurred while
    ///            attempting to sava the item.
    func delete() -> Promise<Void> {
        return Promise { promise in
            AWSDynamoDBObjectMapper.default()
                .remove(self)
                .continueWith { task -> Any? in
                    promise.resolve(task.error)
                    return nil
            }
        }
    }
}
