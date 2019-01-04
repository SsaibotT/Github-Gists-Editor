//
//  Event.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/29/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

struct Event: Codable {
    let id: String
    let files: [String: File]
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case id
        case files
        case owner
        
    }
    
    init(id: String, owner: Owner) {
        self.id = id
        self.files = Dictionary()
        self.owner = owner
    }
}
