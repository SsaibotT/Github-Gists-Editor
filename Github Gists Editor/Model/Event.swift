//
//  Event.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/29/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    let url, forksURL, commitsURL: String
    let id, nodeID: String
    let gitPullURL, gitPushURL: String
    let htmlURL: String
    let files: [String: File]
    let eventPublic: Bool
    let createdAt, updatedAt: String
    let description: String?
    let comments: Int
    let user: JSONNull?
    let commentsURL: String
    let owner: Owner
    let truncated: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case url
        case forksURL    = "forks_url"
        case commitsURL  = "commits_url"
        case id
        case nodeID      = "node_id"
        case gitPullURL  = "git_pull_url"
        case gitPushURL  = "git_push_url"
        case htmlURL     = "html_url"
        case files
        case eventPublic = "public"
        case createdAt   = "created_at"
        case updatedAt   = "updated_at"
        case description, comments, user
        case commentsURL = "comments_url"
        case owner, truncated
    }
}
