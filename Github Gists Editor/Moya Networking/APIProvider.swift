//
//  AuthPlagin.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/2/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya

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
        
        return MoyaProvider<MultiTarget>(endpointClosure: endpointClosure)
    }
}
