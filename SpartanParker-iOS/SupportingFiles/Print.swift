//
//  Print.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 9/5/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

func debugPrintMessage(_ items: Any...) {
    #if DEBUG
        print(items)
    #endif
}
