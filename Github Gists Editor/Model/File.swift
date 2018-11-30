//
//  File.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/29/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

struct File: Codable {
    let filename, type: String
    let language: String?
    let rawURL: String
    let size: Int
    
    enum CodingKeys: String, CodingKey {
        case filename, type, language
        case rawURL = "raw_url"
        case size
    }
}
