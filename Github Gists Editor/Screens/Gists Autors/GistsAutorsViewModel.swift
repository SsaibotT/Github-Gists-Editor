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
import RealmSwift
import RxRealm
import Realm
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
        
        if publicBool {
            
            provider.rx.request(moyaRequest)
                .map([Event].self)
                .asObservable()
                .bind(to: actors)
                .disposed(by: disposeBag)

        } else {
            
            let realm = try! Realm()
            let result = realm.objects(EventRLM.self)
            
//            try! realm.write {
//                realm.deleteAll()
//            }
            
            provider.rx.request(moyaRequest)
                .map([Event].self)
                .asObservable()
                .subscribe(onNext: { events in
                    
                    for event in events {
                        let eventRLM = EventRLM(value: ["id": event.id,
                                                        "owner": ["login": event.owner.login,
                                                                  "avatarURL": event.owner.avatarURL]])

                        do {
                            try realm.write {
                                realm.add(eventRLM, update: true)
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                })
                .disposed(by: disposeBag)
            
            Observable.collection(from: result)
                .subscribe(onNext: { [unowned self] items in
                    print("Query returned \(items.count) items")
                    var events = [Event]()
                    for item in items {
                        let owner = Owner(login: item.owner!.login, avatarURL: item.owner!.avatarURL)
                        let event = Event(id: item.id, owner: owner)
                        events.append(event)
                    }
                    
                    self.actors.accept(events)
                })
                .disposed(by: disposeBag)
        }
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
    
    func pullToRefresh(refresher: UIRefreshControl, provider: MoyaProvider<MultiTarget>, publicBool: Bool) {
        refresher.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] in
                self.getRequest(provider: provider, publicBool: publicBool)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    refresher.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func delete(index: Int) {
        var array = actors.value
        array.remove(at: index)
        actors.accept(array)
    }
}

//        provider.rx.request(moyaRequest)
//            .map([Event].self)
//            .asObservable()
//            .bind(to: actors)
//            .disposed(by: disposeBag)
//
//        if !publicBool {
//            Observable.from(optional: actors.value)
//                .subscribe(Realm.rx.add())
//                .disposed(by: disposeBag)
//
//            let realm = RealmService.shared.realm
//            let result = realm.objects(Event.self)
//
//            Observable.collection(from: result)
//                .subscribe(onNext: { items in
//                    print("Query returned \(items.count) items")
//                    self.actors.accept(items.toArray())
//                })
//                .disposed(by: disposeBag)
//        }
