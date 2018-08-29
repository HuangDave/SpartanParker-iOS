//
//  DatabaseObject.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class DatabaseObject: Codable {
    
    private enum AttributeKeys: String, CodingKey {
        case uid
        case createdAt
        case updatedAt
    }
 
    private(set) var uid:       String = ""
    private(set) var createdAt: String = ""
    private(set) var updatedAt: String = ""
    
    func serialized() -> [String: Any] {
        return [
            AttributeKeys.uid.rawValue:       uid       as Any,
            AttributeKeys.createdAt.rawValue: createdAt as Any,
            AttributeKeys.updatedAt.rawValue: updatedAt as Any,
        ]
    }
}

extension DatabaseObject: CustomStringConvertible {
    
    var description: String { return serialized().description }
}
