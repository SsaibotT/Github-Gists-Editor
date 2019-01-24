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
    var realmItems: Results<Event>!
    
    init(provider: MoyaProvider<MultiTarget>, isPublic: Bool) {
        getRequest(provider: provider, isPublic: isPublic)
        
        var predicate = NSPredicate()
        
        if isPublic {
            predicate = NSPredicate(format: "owner.login != %@", "SsaibotT")
        } else {
            predicate = NSPredicate(format: "owner.login == %@", "SsaibotT")
        }
        realmItems = realm.objects(Event.self).filter(predicate)
        
        Observable
            .collection(from: realmItems)
            .map({ $0.toArray() })
            .map({ (events) -> [Event] in
                events.forEach({ $0.localID = $0.id })
                return events
            })
            .bind(to: actors)
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
        
        provider.rx.request(moyaRequest)
            .map([Event].self)
            .asObservable()
            .subscribe(onNext: { [weak self] events in
                guard let sSelf = self else { return }
                
                ids = events.map { $0.id }

                var objectToDelete: [Event] = []

                if isPublic {
                    let predicateArgStr = "NOT id IN %@ AND isPublic == %d"
                    let predicate = NSPredicate(format: predicateArgStr, ids, true)
                    objectToDelete = sSelf.realmItems.filter(predicate).toArray()
                } else {
                    let predicateArgStr = "NOT id IN %@ AND owner.login == %@"
                    let predicate = NSPredicate(format: predicateArgStr, ids, "SsaibotT")
                    objectToDelete = sSelf.realmItems.filter(predicate).toArray()
                }
                
                let arr = events.sorted { $0.updatedAt < $1.updatedAt }
                print(arr.map{$0.updatedAt})
//                let arr2 = events.sorted { $0.convertedUpdateDate > $1.convertedUpdateDate }
//                print(arr2.map{$0.updatedAt})
                
                do {
                    try sSelf.realm.write {
                        sSelf.realm.add(events, update: true)
                        sSelf.realm.delete(objectToDelete)
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
