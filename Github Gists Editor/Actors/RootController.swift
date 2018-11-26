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

class RootController: UITableViewController {
    
    var actorsViewModel = ActorsViewModel()
    var disposeBag      = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = nil
        tableView.dataSource = nil
        
        actorsViewModel.downloadRepositories()
        setupBindings()
    }
    
    func setupBindings() {
        actorsViewModel.actors
            .asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: "Cell", cellType: ActorTableViewCell.self)) {(_, actor, cell) in
                    cell.cellConfiguration(image: actor.avatar, name: actor.name)
        }.disposed(by: disposeBag)
    }
}
