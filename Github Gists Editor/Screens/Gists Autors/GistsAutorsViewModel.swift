//
//  GistsAutorsViewModel.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class GistsAutorsViewModel {
    
    var actors: BehaviorRelay<[Event]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    
    init(provider: MoyaProvider<MultiTarget>, isPublic: Bool) {
        getRequest(provider: provider, publicBool: isPublic)
    }
    
    func getRequest(provider: MoyaProvider<MultiTarget>, publicBool: Bool) {
        
        var moyaRequest: MultiTarget
        
        if publicBool {
            moyaRequest = MultiTarget(MoyaGistsAutorsEndPoints.getPublicEvents)
        } else {
            moyaRequest = MultiTarget(MoyaPrivateFilesEndPoint.getPrivateEvents)
        }
        
        provider.rx.request(moyaRequest)
            .map([Event].self)
            .asObservable()
            .bind(to: actors)
            .disposed(by: disposeBag)
    }
    
    func deleteRequest(provider: MoyaProvider<MultiTarget>, id: String) {
        
        let moyaRequest = MultiTarget(MoyaPrivateFilesEndPoint.deleteUser(id))
        
        provider.rx.request(moyaRequest)
            .asObservable()
            .subscribe(onNext: { (response) in
                print(response)
            })
            .disposed(by: disposeBag)
    }
    
    func delete(index: Int) {
        var array = actors.value
        array.remove(at: index)
        actors.accept(array)
    }
}
