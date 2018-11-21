//
//  Vehicle.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 11/20/18.
//  Copyright © 2018 David. All rights reserved.
//

import AWSCore
import AWSDynamoDB
import PromiseKit

class Vehicle: AWSDynamoDBObjectModel {
    @objc private(set) var licensePlate: String!
    @objc private(set) var ownerId:      String!
    @objc private(set) var make:         String!
    @objc private(set) var model:        String!
    @objc private(set) var year:         NSNumber!
}

extension Vehicle: AWSDynamoDBModeling {
    class func dynamoDBTableName() -> String {
        return "Vehicle"
    }

    class func hashKeyAttribute() -> String {
        return "licensePlate"
    }
}
