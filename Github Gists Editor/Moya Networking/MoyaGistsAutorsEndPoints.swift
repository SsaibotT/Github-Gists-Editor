//
//  MoyaGistsAutorsEndPoints.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya

enum MoyaGistsAutorsEndPoints {
    
    static var username = "SsaibotT"
    
    case getPublicEvents
    case getPrivateEvents
}

extension MoyaGistsAutorsEndPoints: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType {
        switch self {
        case .getPrivateEvents:
            return .basic
        case .getPublicEvents:
            return .none
        }
    }
    
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var path: String {
        switch self {
        case .getPublicEvents:
            return "/gists/public"
        case .getPrivateEvents:
            return "/users/\(MoyaGistsAutorsEndPoints.username)/gists"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPublicEvents:
            return .get
        case .getPrivateEvents:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getPublicEvents:
            return .requestPlain
        case .getPrivateEvents:
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getPublicEvents:
            return Data()
        case .getPrivateEvents:
            return Data()
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
