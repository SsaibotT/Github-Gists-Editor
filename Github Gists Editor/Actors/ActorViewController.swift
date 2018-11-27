//
//  RootController.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class ActorViewController: UITableViewController {
    
    let moyaProvider    = MoyaProvider<MoyaGithubEndpoints>()
    var actorsViewModel: ActorsViewModel!
    var disposeBag      = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = nil
        tableView.dataSource = nil
        
        let nibName = UINib(nibName: "ActorTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ActorTableViewCell")
        
        actorsViewModel = ActorsViewModel(provider: moyaProvider)
        setupBindings()
    }
    
    func setupBindings() {
        actorsViewModel.actors
            .asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: "ActorTableViewCell", cellType: ActorTableViewCell.self)) {(_, event, cell) in
                    cell.cellConfiguration(events: event)
            }
            .disposed(by: disposeBag)
    }
}
