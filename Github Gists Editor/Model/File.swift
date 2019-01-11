//
//  File.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/29/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class File: Object, Decodable {
    @objc dynamic var filename = ""
    @objc dynamic var rawURL = ""
    
    enum CodingKeys: String, CodingKey {
        case filename
        case rawURL = "raw_url"
    }
    
    override static func primaryKey() -> String? {
        return "filename"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        filename = try container.decode(String.self, forKey: .filename)
        rawURL   = try container.decode(String.self, forKey: .rawURL)
        
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
