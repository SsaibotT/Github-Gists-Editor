//
//  AuthPlagin.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/2/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

struct APIProvider {
    
    static func provider() -> MoyaProvider<MultiTarget> {
        let endpointClosure = { (target: MultiTarget) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let sampleResponse: Endpoint.SampleResponseClosure = { .networkResponse(200, target.sampleData) }
            var endpoint = Endpoint(url: url,
                                    sampleResponseClosure: sampleResponse,
                                    method: target.method,
                                    task: target.task,
                                    httpHeaderFields: nil)
            
            switch target.target {
            case is MoyaPrivateFilesEndPoint:
                let authorization = ["Authorization": "Basic " + "MVNzYWlib3RUMUBnbWFpbC5jb206c2FpYm90MXJhbWJsZXJydQ=="]
                endpoint = endpoint.adding(newHTTPHeaderFields: authorization)
            default:
                break
            }
            
            return endpoint
        }
        
        let networkLoggerPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)
        let plugins: [PluginType] = [networkLoggerPlugin]
        
        return MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, plugins: plugins)
    }
}
