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
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/gists"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .createUser(let gistInfo):
            return "{'description': '\(gistInfo.description)','public': \(gistInfo.isPublic), 'files': {'\(gistInfo.fileName)': {'content': '\(gistInfo.content)'}}}".data(using: .utf8)!
        }
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
