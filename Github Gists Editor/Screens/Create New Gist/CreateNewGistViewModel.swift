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
    
    var uploadButtonResult: Observable<Bool>!
    
    var isValid: Bool {
        return fileName.value.count > 0
            && content.value.count > 0
            && selectedType.value.count > 0
    }
    
    init(tapButton: Observable<Void>, provider: MoyaProvider<MultiTarget>) {
        
        let validation = Observable.combineLatest(fileName.asObservable(),
                                                  content.asObservable(),
                                                  selectedType.asObservable())
        
        uploadButtonResult = tapButton
            .withLatestFrom(validation)
            .flatMapLatest({ [unowned self] (fileName, content, selectedType) -> Observable<Bool> in
                guard self.isValid else { return Observable.just(false)}
                
                self.gistCreationInfo.description = fileName
                self.gistCreationInfo.fileName    = fileName + selectedType
                self.gistCreationInfo.content     = content
                
                return provider.rx.request(MultiTarget.target(MoyaPrivateFilesEndPoint
                    .createUser(self.gistCreationInfo)))
                    .asObservable()
                    .flatMapLatest({ (_) -> Observable<Bool> in
                        return Observable.just(true)
                    })
        })
    }
    
    func isPublic(index: Int) {
        if index == 0 {
            gistCreationInfo.isPublic = true
        } else {
            gistCreationInfo.isPublic = false
        }
    }
}
