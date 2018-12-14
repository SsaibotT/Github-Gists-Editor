//
//  MoyaPrivateFilesEndPoint.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/5/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya

enum MoyaPrivateFilesEndPoint {
    
    case getPrivateEvents
}

extension MoyaPrivateFilesEndPoint: TargetType {
    
    public var baseURL: URL {
        return URL(string: Constants.githubOriginalSite)!
    }
    
    public var path: String {
        switch self {
        case .getPrivateEvents:
            return Constants.getGists(by: Constants.nickNameSsaibotT)
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPrivateEvents:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getPrivateEvents:
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getPrivateEvents:
            return Data()
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
