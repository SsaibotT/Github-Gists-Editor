//
//  GistsAutorsTableViewController.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class GistsAutorsTableViewController: UITableViewController {
    
    static let source = TokenSource()
    let moyaProvider = MoyaProvider<MultiTarget>(
        plugins: [
            AuthPlugin(tokenClosure: { return "MVNzYWlib3RUMUBnbWFpbC5jb206c2FpYm90MXJhbWJsZXJydQ==" })
        ]
    )

    private var gistsViewModel: GistsAutorsViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = nil
        tableView.dataSource = nil
        
        let nibName = UINib(nibName: "GistsAutorsTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: GistsAutorsTableViewCell.identifier)

        choosingTableViewController()
        setupBindings()
    }
    
    func choosingTableViewController() {
//        if tabBarController?.selectedIndex == 9223372036854775807 {
        if tabBarController?.selectedIndex == 0 {
            gistsViewModel = GistsAutorsViewModel(provider: moyaProvider, isPublic: false)
        } else {
            gistsViewModel = GistsAutorsViewModel(provider: moyaProvider, isPublic: true)
        }
    }
    
    private func setupBindings() {
        
        gistsViewModel.actors
            .asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: GistsAutorsTableViewCell.identifier,
                       cellType: GistsAutorsTableViewCell.self)) {(_, event, cell) in
                        cell.cellConfiguration(events: event)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in
                self.goToChooseFileVC(index: $0.row)
            })
            .disposed(by: disposeBag)
    }
    
    private func goToChooseFileVC(index: Int) {
        let data = gistsViewModel.actors.value[index]
        ShowControllers.showGistFilesOfAutors(from: self, data: data)
    }
}
