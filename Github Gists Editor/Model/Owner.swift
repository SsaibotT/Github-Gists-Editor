//
//  Owner.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/29/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

struct Owner: Codable {
    let login: String
    var avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
    
    init(login: String, avatarURL: String) {
        self.login     = login
        self.avatarURL = avatarURL
    }
}
