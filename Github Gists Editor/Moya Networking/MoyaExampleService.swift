//
//  MoyaExampleService.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 Serhii. All rights reserved.

import Foundation
import Moya

//private func JSONResponseDataFormatter(_ data: Data) -> Data {
//    do {
//        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
//        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
//        return prettyData
//    } catch {
//        return data 
//    }
//}

//let moyaExample = MoyaProvider<MoyaExampleService>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

enum MoyaExampleService {
    case getEvents
}

extension MoyaExampleService: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var path: String {
        switch self {
        case .getEvents:
            return "/events"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getEvents:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getEvents:
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getEvents:
            return Data()
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
