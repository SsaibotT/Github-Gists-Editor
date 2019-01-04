//
//  Files.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/2/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

//import Foundation
//import RealmSwift
//import Realm
//
//class Files: Object, Decodable {
//    
//    @objc dynamic var name: String = ""
//    var file = List<File>()
//    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case file
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        name = try container.decode(String.self, forKey: .name)
//        
//        let theFile = try container.decode([File].self, forKey: .file)
//        file.append(objectsIn: theFile)
//        
//        super.init()
//    }
//    
//    required init() {
//        super.init()
//    }
//    
//    required init(value: Any, schema: RLMSchema) {
//        super.init(value: value, schema: schema)
//    }
//    
//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        super.init(realm: realm, schema: schema)
//    }
//}
