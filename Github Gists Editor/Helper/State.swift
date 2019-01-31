//
//  State.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/31/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import Foundation

enum State: Int {
    case List
    case Grid
    
    var indexValue: Int {
        switch self {
        case .List:
            return 0
        case .Grid:
            return 1
        }
    }
}
