//
//  Constants.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/14/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

struct Constants {
    static let nickNameSsaibotT = "SsaibotT"
    static let githubOriginalSite = "https://api.github.com"
    static let githubPublic = "/gists/public"
    static let userGists = "/gists"
    
    static func getGists(by nickname: String) -> String {
        return "/users/\(nickname)/gists"
    }
}
