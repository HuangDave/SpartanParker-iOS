//
//  DatabaseObject.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

class DatabaseObject: Codable {
    private enum CodingKeys: String, CodingKey {
        case uid
        case createdAt
        case updatedAt
    }

    private(set) var uid:       String = ""
    private(set) var createdAt: String = ""
    private(set) var updatedAt: String = ""

    func serialized() -> JSON {
        return [
            CodingKeys.uid.rawValue:       uid       as Any,
            CodingKeys.createdAt.rawValue: createdAt as Any,
            CodingKeys.updatedAt.rawValue: updatedAt as Any
        ]
    }
}

extension DatabaseObject: CustomStringConvertible {
    var description: String { return serialized().description }
}
