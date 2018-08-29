//
//  User.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/24/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

// MARK: -
class User: DatabaseObject {

    private enum AttributeKeys: String, CodingKey {
        case fullName
        case email
        case password
    }
    
    private enum FullNameKeys: String, CodingKey {
        case first
        case last
    }
    
    struct FullName: Codable {
        var first: String = ""
        var last:  String = ""
    }
    
    static private(set) var currentUser: User?
    
    var fullName: FullName = FullName()
    var email:    String = ""
    var password: String = ""
    
    required init(from decoder: Decoder) throws {
        let container         = try decoder.container(keyedBy: AttributeKeys.self)
        let fullNameContainer = try container.nestedContainer(keyedBy: FullNameKeys.self, forKey: .fullName)
        fullName.first        = try fullNameContainer.decode(String.self, forKey: .first)
        fullName.last         = try fullNameContainer.decode(String.self, forKey: .last)
        email                 = try container.decode(String.self, forKey: .email)
        password              = try container.decode(String.self, forKey: .password)
        try super.init(from: decoder)
    }
    
    override func serialized() -> [String: Any] {
        var data = super.serialized()
        data[AttributeKeys.fullName.rawValue] = [
            FullNameKeys.first.rawValue: fullName.first,
            FullNameKeys.last.rawValue:  fullName.last,
        ]
        data[AttributeKeys.email.rawValue]    = email
        data[AttributeKeys.password.rawValue] = password
        return data
    }
}

// MARK: -
extension User {
    
    class func register(user: User) {
        
    }
    
    class func login(user: User) {
        
    }
    
}
