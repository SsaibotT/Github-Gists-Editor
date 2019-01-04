//
//  File.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/29/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

struct File: Codable {
    let filename: String
    let rawURL: String
    
    enum CodingKeys: String, CodingKey {
        case filename
        case rawURL = "raw_url"
    }
}
