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
    
    let moyaProvider = APIProvider.provider()

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
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController!.title = "Root View Controller"
        navigationBar()
    }
    
    func navigationBar() {
        let navItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                      target: self,
                                      action: #selector(GistsAutorsTableViewController.addNewGist))
        navigationItem.rightBarButtonItem = navItem
    }
    
    @objc func addNewGist() {
        gotoNewGistVC()
    }
    
    func choosingTableViewController() {
        if tabBarController?.selectedIndex == 0 {
            gistsViewModel = GistsAutorsViewModel(provider: moyaProvider, isPublic: true)
        } else {
            gistsViewModel = GistsAutorsViewModel(provider: moyaProvider, isPublic: false)
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
    
    private func gotoNewGistVC() {
        ShowControllers.showCreateNewGist(from: self)
    }
}
