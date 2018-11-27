//
//  RootViewModel.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class ActorsViewModel {
    
    var actors: BehaviorRelay<[Event]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    
    init(provider: MoyaProvider<MoyaGithubEndpoints>) {
        provider.rx.request(.getEvents)
            .map([Event].self)
            .asObservable()
            .bind(to: actors)
            .disposed(by: disposeBag)
    }
}
