//
//  AuthPlagin.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/2/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya

class TokenSource {
    var token: String?
    init() { }
}

struct AuthPlugin: PluginType {
    let tokenClosure: () -> String?
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        guard
            let token = tokenClosure(),
            let target = target as? AuthorizedTargetType,
            target.needsAuth
            else {
                return request
        }
        
        print("im here")
        var request = request
        request.addValue("Basic " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}

protocol AuthorizedTargetType: TargetType {
    var needsAuth: Bool { get }
}
