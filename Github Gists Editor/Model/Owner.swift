//
//  Owner.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/29/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Owner: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var login = ""
    @objc dynamic var avatarURL = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id        = try container.decode(Int.self, forKey: .id)
        login     = try container.decode(String.self, forKey: .login)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
        
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
