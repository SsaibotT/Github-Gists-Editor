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
    
    case getPublicEvents
}

extension MoyaGistsAutorsEndPoints: TargetType {
    
    public var baseURL: URL {
        return URL(string: Constants.githubOriginalSite)!
    }
    
    public var path: String {
        switch self {
        case .getPublicEvents:
            return Constants.githubPublic
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPublicEvents:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getPublicEvents:
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getPublicEvents:
            return Data()
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
