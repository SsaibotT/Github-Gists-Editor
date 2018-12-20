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
    var publicBool: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = nil
        tableView.dataSource = nil
        
        let nibName = UINib(nibName: "GistsAutorsTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: GistsAutorsTableViewCell.identifier)
        
        choosingTableViewController()
        setupBindings()
        pullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController!.title = "Root View Controller"
        navigationBar()
    }
    
    // MARK: Navigation
    private func navigationBar() {
        let navItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                      target: self,
                                      action: #selector(GistsAutorsTableViewController.addNewGist))
        navigationItem.rightBarButtonItem = navItem
    }
    
    @objc private func addNewGist() {
        gotoNewGistVC()
    }
    
    private func choosingTableViewController() {
        gistsViewModel = GistsAutorsViewModel(provider: moyaProvider, isPublic: publicBool)
    }
    
    // MARK: rx
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
                self.tableView.deselectRow(at: $0, animated: false)
            })
            .disposed(by: disposeBag)
        
        if self.tabBarController?.selectedIndex == 1 {
            tableView.rx.itemDeleted
                .subscribe(onNext: { [unowned self] (index) in
                    let id = self.gistsViewModel.actors.value[index.row].id
                    self.gistsViewModel.deleteRequest(provider: self.moyaProvider, id: id)
                    self.gistsViewModel.delete(index: index.row)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func pullToRefresh() {
        let refresher = UIRefreshControl()
        tableView.refreshControl = refresher
        
        gistsViewModel.pullToRefresh(refresher: refresher,
                                     provider: moyaProvider,
                                     publicBool: publicBool)
    }
    
    // MARK: Jumping to new VC
    private func goToChooseFileVC(index: Int) {
        let data = gistsViewModel.actors.value[index]
        ShowControllers.showGistFilesOfAutors(from: self, data: data)
    }
    
    private func gotoNewGistVC() {
        ShowControllers.showCreateNewGist(from: self)
    }
}
