//
//  Event.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/29/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Event: Object, Decodable {
    @objc dynamic var id = ""
    @objc dynamic var isPublic = false
    let files = List<File>()
    @objc dynamic var owner: Owner?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isPublic = "public"
        case files
        case owner
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id       = try container.decode(String.self, forKey: .id)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
        owner    = try container.decode(Owner.self, forKey: .owner)
        let filesDictionary = try container.decode([String: File].self, forKey: .files)
        
        let file = Array(filesDictionary.values)
        for value in file {
            files.append(value)
        }
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
