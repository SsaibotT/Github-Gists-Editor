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
import RxDataSources
import Moya

class GistsAutorsTableViewController: UITableViewController {
    
    let moyaProvider = APIProvider.provider()
    
    private var gistsViewModel: GistsAutorsViewModel!
    private var disposeBag = DisposeBag()
    var isPublic: Bool!
    
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
        gistsViewModel = GistsAutorsViewModel(provider: moyaProvider, isPublic: isPublic)
    }
    
    // MARK: rx
    private func setupBindings() {
        
        gistsViewModel.datasource.configureCell = { (_, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: GistsAutorsTableViewCell.identifier,
                                                     for: indexPath) as? GistsAutorsTableViewCell
            cell!.cellConfiguration(events: item)
            return cell!
        }
        
        gistsViewModel.datasource.canEditRowAtIndexPath = { (_, _) in
            return true
        }
        
        if let eventDataSource = gistsViewModel?.datasource {
            gistsViewModel.actors
                .asObservable()
                .map({[SectionOfCustomData(header: "First Section", items: $0)]})
                .bind(to: tableView.rx.items(dataSource: eventDataSource))
                .disposed(by: disposeBag)
        }
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in
                self.goToChooseFileVC(index: $0.row)
                self.tableView.deselectRow(at: $0, animated: false)
            })
            .disposed(by: disposeBag)

        if !self.isPublic {
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
        refresher.tintColor = .white
        tableView.refreshControl = refresher
        
        gistsViewModel.pullToRefresh(refresher: refresher,
                                     provider: moyaProvider,
                                     isPublic: isPublic)
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
