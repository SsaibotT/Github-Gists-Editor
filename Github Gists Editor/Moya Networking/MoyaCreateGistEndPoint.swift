//
//  CreateGist.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/8/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya

enum MoyaCreateGistEndPoint {

    case createUser(GistCreationInfo)
}

extension MoyaCreateGistEndPoint: TargetType {
    var baseURL: URL {
        return URL(string: Constants.githubOriginalSite)!
    }
    
    var path: String {
        switch self {
        case .createUser:
            return Constants.userGists
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .createUser(let creationInfo):
            return .requestParameters(parameters: ["description": creationInfo.description,
                                                   "public": creationInfo.isPublic,
                                                   "files": [creationInfo.fileName: ["content": creationInfo.content]]],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
