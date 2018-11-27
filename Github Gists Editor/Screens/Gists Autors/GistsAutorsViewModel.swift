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
    let disposeBag = DisposeBag()
    
    init(provider: MoyaProvider<MoyaGistsAutorsEndPoints>) {
        provider.rx.request(.getEvents)
            .map([Event].self)
            .asObservable()
            .bind(to: actors)
            .disposed(by: disposeBag)
    }
}
