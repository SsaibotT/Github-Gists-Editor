//
//  OwnerRLM.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/4/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class OwnerRLM: Object {
    @objc dynamic var login = ""
    @objc dynamic var avatarURL = ""
}
