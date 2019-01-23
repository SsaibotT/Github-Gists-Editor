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
import RxDataSources

class GistsAutorsViewModel {
    
    var actors: BehaviorRelay<[Event]> = BehaviorRelay(value: [])
    var datasource = RxTableViewSectionedAnimatedDataSource<SectionOfCustomData>(configureCell: { (_, _, _, _) in
        fatalError()})
    private let disposeBag = DisposeBag()
    // swiftlint:disable:next force_try
    let realm = try! Realm()
    var filteredEvent = [Event]()
    
    init(provider: MoyaProvider<MultiTarget>, isPublic: Bool) {
        getRequest(provider: provider, isPublic: isPublic)
        
        let result = realm.objects(Event.self)
        
        Observable.collection(from: result)
            .subscribe(onNext: { [unowned self] items in

                var predicate = NSPredicate()
                
                if isPublic {
                    predicate = NSPredicate(format: "owner.login != %@", "SsaibotT")
                } else {
                    predicate = NSPredicate(format: "owner.login == %@", "SsaibotT")
                }

                self.filteredEvent = items.filter(predicate).toArray()
                
                for event in self.filteredEvent {
                    event.localID = event.id
                }

                self.actors.accept(self.filteredEvent)
                
            })
            .disposed(by: disposeBag)
    }
    
    func getRequest(provider: MoyaProvider<MultiTarget>, isPublic: Bool) {
        
        var moyaRequest: MultiTarget
        
        if isPublic {
            moyaRequest = MultiTarget(MoyaGistsAutorsEndPoints.getPublicEvents)
        } else {
            moyaRequest = MultiTarget(MoyaPrivateFilesEndPoint.getPrivateEvents)
        }

        var ids = [String]()
        let result = realm.objects(Event.self)
        
        provider.rx.request(moyaRequest)
            .map([Event].self)
            .asObservable()
            .subscribe(onNext: { events in
                
                ids = events.map { $0.id }

                var objectToDelete: [Event] = []

                if isPublic {
                    let predicateArgStr = "NOT id IN %@ AND isPublic == %d AND owner.login != %@"
                    let predicate = NSPredicate(format: predicateArgStr, ids, true, "SsaibotT")
                    objectToDelete = result.filter(predicate).toArray()
                } else {
                    let predicateArgStr = "NOT id IN %@ AND isPublic != %d AND owner.login == %@"
                    let predicate = NSPredicate(format: predicateArgStr, ids, false, "SsaibotT")
                    objectToDelete = result.filter(predicate).toArray()
                }
                
                do {
                    try self.realm.write {
                        self.realm.add(events, update: true)
                        self.realm.delete(objectToDelete)
                    }
                } catch {
                    print(error)
                }
             })
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
    
    func pullToRefresh(refresher: UIRefreshControl, provider: MoyaProvider<MultiTarget>, isPublic: Bool) {
        refresher.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] in
                self.getRequest(provider: provider, isPublic: isPublic)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    refresher.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func delete(index: Int) {
        deletingPrivateGistFromRealmAt(index: index)
        
        var array = actors.value
        array.remove(at: index)
        actors.accept(array)
    }
    
    func deletingPrivateGistFromRealmAt(index: Int) {
        guard let realm = try? Realm() else { return }
        let result = realm.objects(Event.self)
        
        let filetredToPrivate = result.toArray().filter { $0.owner?.login == "SsaibotT" }
        let objectToDelete = filetredToPrivate[index]
        
        do {
            try realm.write {
                realm.delete(objectToDelete)
            }
        } catch {
            print(error)
        }
    }
}
