//
//  RootController.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Moya

class RootController: UITableViewController {
    let moyaProvider = MoyaProvider<MoyaExampleService>()
    var event = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = nil
        tableView.dataSource = nil
        // Do any additional setup after loading the view, typically from a nib.
        
        downloadRepositories()
    }
    
    func setupBindings() {
        
    }
    
    func downloadRepositories() {
        moyaProvider.request(.getEvents) { result in
            switch result {
            case .success(let response):
                guard let events = try? JSONDecoder().decode(Events.self, from: response.data) else { return }
                for element in events {
                    print(element.actor.avatarURL)
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
