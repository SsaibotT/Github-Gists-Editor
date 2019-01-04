//
//  EventRLM.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/4/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class EventRLM: Object {
    @objc dynamic var id = ""
    let files = List<FilesDictionaryRLM>()
    @objc dynamic var owner: OwnerRLM?
    
    override static func primaryKey() -> String {
        return "id"
    }
}
