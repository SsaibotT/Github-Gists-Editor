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
    
    private var gistCreationInfo = GistCreationInfo(description: "", isPublic: true, fileName: "", content: "")
    let types: BehaviorRelay<[String]> = BehaviorRelay(value: [".txt", ".html"])
    let disposeBag = DisposeBag()
    
    var fileName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var content: BehaviorRelay<String>  = BehaviorRelay(value: "")
    var selectedType: BehaviorRelay<String> = BehaviorRelay(value: "")
//    var isValid: Observable<Bool>
    
    var testValid: Bool! {
        return fileName.value.count > 0
            && content.value.count > 0
            && selectedType.value.count > 0
    }
    
//    init() {
//
//        isValid = Observable.combineLatest(self.fileName.asObservable(),
//                                           self.content.asObservable(),
//                                           self.selectedType.asObservable()) { (fileName, content, selectedType) in
//            return fileName.count > 0
//                && content.count > 0
//                && selectedType.count > 0
//        }
//    }
    
    func getRequest(provider: MoyaProvider<MultiTarget>) {
        gistCreationInfo.description = fileName.value
        gistCreationInfo.fileName    = "file" + selectedType.value
        gistCreationInfo.content     = content.value
        
        provider.request(MultiTarget.target(MoyaCreateGistEndPoint
            .createUser(gistCreationInfo))) { response in
            switch response {
            case .success(let result):
                print(result.data)
            default:
                break
            }
        }
    }
    
    func isPublic(index: Int) {
        if index == 0 {
            gistCreationInfo.isPublic = true
        } else {
            gistCreationInfo.isPublic = false
        }
    }
}
