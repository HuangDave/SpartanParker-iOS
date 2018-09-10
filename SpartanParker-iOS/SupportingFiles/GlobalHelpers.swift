//
//  GlobalHelpers.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/10/18.
//  Copyright © 2018 David. All rights reserved.
//

public func create <T: AnyObject>(_ object: T, setup: (T) throws -> Void) rethrows -> T {
    try setup(object)
    return object
}
