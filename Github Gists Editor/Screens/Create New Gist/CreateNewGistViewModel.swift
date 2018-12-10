//
//  CreateNewGistViewModel.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/10/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

class CreateNewGistViewModel {
    
    var gistCreationInfo = GistCreationInfo(description: "", isPublic: true, fileName: "", content: "")
    let types: BehaviorRelay<[String]> = BehaviorRelay.init(value: [".txt", ".html"])
    let disposeBag = DisposeBag()
    
    func getRequest(provider: MoyaProvider<MultiTarget>, fileName: String, selectedType: String, content: String) {
        gistCreationInfo.description = fileName
        gistCreationInfo.fileName    = "file" + selectedType
        gistCreationInfo.content     = content
        
        provider.request(MultiTarget.target(MoyaCreateGistEndPoint
            .createUser(gistCreationInfo))) { response in
            switch response {
            case .success(let result):
                print(result.data)
            default:
                print("some")
            }
        }
    }
    
    func isPublic(segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            gistCreationInfo.isPublic = true
        } else {
            gistCreationInfo.isPublic = false
        }
    }
}
