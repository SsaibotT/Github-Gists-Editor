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
    case createUser(GistCreationInfo)
    case deleteUser(String)
}

extension MoyaPrivateFilesEndPoint: TargetType {
    
    public var baseURL: URL {
        return URL(string: Constants.githubOriginalSite)!
    }
    
    public var path: String {
        switch self {
        case .getPrivateEvents:
            return Constants.getGists(by: Constants.nickNameSsaibotT)
        case .createUser:
            return Constants.userGists
        case .deleteUser(let id):
            return "/gists/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPrivateEvents:
            return .get
        case .createUser:
            return .post
        case .deleteUser:
            return .delete
        }
    }
    
    public var task: Task {
        switch self {
        case .getPrivateEvents, .deleteUser:
            return .requestPlain
        case .createUser(let creationInfo):
            return .requestParameters(parameters: ["description": creationInfo.description,
                                                   "public": creationInfo.isPublic,
                                                   "files": [creationInfo.fileName: ["content": creationInfo.content]]],
                                      encoding: JSONEncoding.default)
        }
    }
    
    public var sampleData: Data {
        return Data()        
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
