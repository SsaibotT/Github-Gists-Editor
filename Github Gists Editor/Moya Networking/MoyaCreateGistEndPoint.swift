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
    
    static var description = ""
    static var isPublic = true
    static var fileName = "file"
    static var content  = ""
    private static var example = "{'description': '\(description)','public': \(isPublic), 'files': {'\(fileName)': {'content': '\(content)'}}}".data(using: .utf8)!
    
    case createUser
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
        case .createUser:
            return MoyaCreateGistEndPoint.example
        }
    }
    
    var task: Task {
        switch self {
        case .createUser:
            return .requestParameters(parameters: ["description": "\(MoyaCreateGistEndPoint.description)",
                                                   "public": MoyaCreateGistEndPoint.isPublic,
                                                   "files": ["\(MoyaCreateGistEndPoint.fileName)": ["content": "\(MoyaCreateGistEndPoint.content)"]]],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
