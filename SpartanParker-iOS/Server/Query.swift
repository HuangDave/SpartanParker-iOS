//
//  Query.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 11/25/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSDynamoDB
import PromiseKit

/// Query helper object used to query items from AWS DynamoDB.
class Query<T: DatabaseObject> {
    enum FetchError: Error {
        case notFound
        case other
    }

    class func get(expression: AWSDynamoDBQueryExpression) -> Promise<T> {
        return Promise { promise in
            AWSDynamoDBObjectMapper.default()
                .query(T.self, expression: expression)
                .continueWith { output -> Any? in
                    if let result = output.result?.items.first as? T {
                        promise.fulfill(result)
                    } else {
                        // debugPrintMessage("ERROR: \(output.error)")
                        promise.reject(FetchError.other)
                    }
                    return nil
            }
        }
    }

    class func get(expression: AWSDynamoDBQueryExpression) -> Promise<[T]> {
        return Promise { promise in
            AWSDynamoDBObjectMapper.default()
                .query(T.self, expression: expression)
                .continueWith { output -> Any? in
                    if let result = output.result?.items as? [T] {
                        promise.fulfill(result)
                    } else {
                        promise.reject(FetchError.other)
                    }
                    return nil
            }
        }
    }
}
