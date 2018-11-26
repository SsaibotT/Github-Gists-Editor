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

class ActorsViewModel {
    
    var actors: Variable<[MyActor]> = Variable([MyActor]())
    let moyaProvider = MoyaProvider<MoyaExampleService>()
    
    func downloadRepositories() {
        moyaProvider.request(.getEvents) { result in
            switch result {
            case .success(let response):
                guard let events = try? JSONDecoder().decode(Events.self, from: response.data) else { return }
                for event in events {
                    guard let imageURL = URL(string: event.actor.avatarURL) else { return }
                    self.actors.value.append(MyActor(avatar: imageURL, name: event.repo.name))
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
