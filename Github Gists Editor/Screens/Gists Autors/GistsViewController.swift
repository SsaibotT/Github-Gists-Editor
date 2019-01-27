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

class GistsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeToListButton: UIButton!
    @IBOutlet weak var changeToGridButton: UIButton!
    
    let moyaProvider = APIProvider.provider()
    
    private var gistsViewModel: GistsAutorsViewModel!
    private var disposeBag = DisposeBag()
    var isPublic: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let tableViewCellNibName = UINib(nibName: "GistsAutorsTableViewCell", bundle: nil)
        let collectionViewCellNibName = UINib(nibName: "GistsAutorsCollectionViewCell", bundle: nil)
        
        //tableView.register(tableViewCellNibName, forCellReuseIdentifier: GistsAutorsTableViewCell.identifier)
        collectionView.register(collectionViewCellNibName,
                                forCellWithReuseIdentifier: GistsAutorsCollectionViewCell.identifier)
        
        choosingTableViewController()
        setupBindings()
        pullToRefresh()
        buttonsTapped()
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
                                      action: #selector(GistsViewController.addNewGist))
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
            let cell = tableView.dequeueReusableCell(withReuseIdentifier: GistsAutorsCollectionViewCell.identifier,
                                                     for: indexPath) as? GistsAutorsCollectionViewCell
            cell!.cellConfiguration(events: item)
            return cell!
        }
        
//        gistsViewModel.datasource.canEditRowAtIndexPath = { (_, _) in
//            return true
//        }
        
        if let eventDataSource = gistsViewModel?.datasource {
            gistsViewModel.actors
                .asObservable()
                .map({[SectionOfCustomData(header: "First Section", items: $0)]})
                .bind(to: collectionView.rx.items(dataSource: eventDataSource))
                .disposed(by: disposeBag)
        }
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in
                self.goToChooseFileVC(index: $0.row)
                self.collectionView.deselectItem(at: $0, animated: false)
            })
            .disposed(by: disposeBag)
//        if let eventDataSource = gistsViewModel?.datasource {
//            gistsViewModel.actors
//                .asObservable()
//                .map({[SectionOfCustomData(header: "First Section", items: $0)]})
//                .bind(to: tableView.rx.items(dataSource: eventDataSource))
//                .disposed(by: disposeBag)
//        }
        
//        tableView.rx.itemSelected
//            .subscribe(onNext: { [unowned self] in
//                self.goToChooseFileVC(index: $0.row)
//                self.tableView.deselectRow(at: $0, animated: false)
//            })
//            .disposed(by: disposeBag)

        if !self.isPublic {
//            tableView.rx.itemDeleted
//                .subscribe(onNext: { [unowned self] (index) in
//                    let id = self.gistsViewModel.actors.value[index.row].id
//                    self.gistsViewModel.deleteRequest(provider: self.moyaProvider, id: id)
//                    self.gistsViewModel.delete(index: index.row)
//                })
//                .disposed(by: disposeBag)
            
        }
    }
    
    private func buttonsTapped() {
        
        changeToGridButton.rx.tap
            .asObservable()
            .subscribe({ [unowned self] (_) in
                self.changeToGridButton.backgroundColor = UIColor.darkGray
                self.changeToListButton.backgroundColor = UIColor.lightGray
            })
            .disposed(by: disposeBag)
        
        changeToListButton.rx.tap
            .asObservable()
            .subscribe({ [unowned self] (_) in
                self.changeToListButton.backgroundColor = UIColor.darkGray
                self.changeToGridButton.backgroundColor = UIColor.lightGray
            })
            .disposed(by: disposeBag)
        
    }
    
    private func pullToRefresh() {
        let refresher = UIRefreshControl()
        refresher.tintColor = .white
        //tableView.refreshControl = refresher
        collectionView.refreshControl = refresher
        
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
