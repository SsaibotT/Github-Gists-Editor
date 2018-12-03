//
//  AuthPlagin.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/2/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya

struct AuthPlugin: PluginType {
    let token: String
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("Basic " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}
