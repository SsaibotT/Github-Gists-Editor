//
//  Actor.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import UIKit

struct MyActor {
    
    var avatar: URL!
    var name: String!
    
    init(avatar: URL, name: String) {
        self.avatar = avatar
        self.name   = name
    }
}
