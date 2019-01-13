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
import PKHUD

class CreateNewGistViewModel {
    
    private var gistCreationInfo = GistCreationInfo(description: "", isPublic: true, fileName: "", content: "")
    let types: BehaviorRelay<[String]> = BehaviorRelay(value: [".txt", ".html"])
    let disposeBag = DisposeBag()
    
    var fileName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var content: BehaviorRelay<String>  = BehaviorRelay(value: "")
    var selectedType: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var uploadButtonResult: Observable<Bool>!
    
    init(tapButton: Observable<Void>, provider: MoyaProvider<MultiTarget>) {
        
        let userInfo = Observable.combineLatest(fileName.asObservable(),
                                                  content.asObservable(),
                                                  selectedType.asObservable())
        
        uploadButtonResult = tapButton
            .withLatestFrom(userInfo)
            .flatMapLatest({ [unowned self] (fileName, content, selectedType) -> Observable<Bool> in
                HUD.show(.progress)
                let isValid: Bool = fileName.count > 0
                    && content.count > 0
                    && selectedType.count > 0
                
                guard isValid else { return Observable.just(false)}
                
                self.gistCreationInfo.description = fileName
                self.gistCreationInfo.fileName    = fileName + selectedType
                self.gistCreationInfo.content     = content
                
                return provider.rx.request(MultiTarget.target(MoyaPrivateFilesEndPoint
                    .createUser(self.gistCreationInfo)))
                    .asObservable()
                    .flatMapLatest({ (_) -> Observable<Bool> in
                        HUD.flash(.success, delay: 1.0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            // Insert showing the private users screen in here
                        }
                        return Observable.just(true)
                    })
        })
    }
    
    func isPublic(index: Int) {
        gistCreationInfo.isPublic = index == 0
    }
}
