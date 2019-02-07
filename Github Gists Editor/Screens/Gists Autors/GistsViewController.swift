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
    
    let moyaProvider = APIProvider.provider()
    
    private var gistsViewModel: GistsAuthorsViewModel!
    private var disposeBag = DisposeBag()
    var isListFlowLayout = true
    var isPublic: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewCellNibName     = UINib(nibName: GistsAuthorsCollectionViewCell.identifier,
                                                  bundle: nil)
        let collectionListViewCellNibName = UINib(nibName: GistsAuthorsListCollectionViewCell.identifier,
                                                  bundle: nil)
        
        collectionView.register(collectionViewCellNibName,
                                forCellWithReuseIdentifier: GistsAuthorsCollectionViewCell.identifier)
        
        collectionView.register(collectionListViewCellNibName,
                                forCellWithReuseIdentifier: GistsAuthorsListCollectionViewCell.identifier)
        
        choosingTableViewController()
        setupBindings()
        pullToRefresh()
        
        collectionView.collectionViewLayout = addingListCollectionLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar()
    }
    
    // MARK: Navigation
    private func navigationBar() {
        let navItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                      target: self,
                                      action: #selector(GistsViewController.addNewGist))
        navigationItem.rightBarButtonItem = navItem
        
        navigationItem.title = "Gists"
    }
    
    @objc private func addNewGist() {
        gotoNewGistVC()
    }
    
    private func choosingTableViewController() {
        gistsViewModel = GistsAuthorsViewModel(provider: moyaProvider, isPublic: isPublic)
    }
    
    // MARK: rx
    private func setupBindings() {

        gistsViewModel.datasource.configureCell = { [unowned self] (_, tableView, indexPath, item) in
            
            if self.isListFlowLayout {
                
                let cellIdentifier = GistsAuthorsListCollectionViewCell.identifier
                guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                               for: indexPath) as? GistsAuthorsListCollectionViewCell else {
                                                                return UICollectionViewCell()}

                if !self.isPublic {
                    cell.deletionButton()
                    
                    cell.passingDeletion = {
                        guard let deletingIndexPath = self.collectionView.indexPath(for: cell) else { return }
                        
                        let id = self.gistsViewModel.authors.value[deletingIndexPath.row].id
                        self.gistsViewModel.deleteRequest(provider: self.moyaProvider, id: id)
                        self.gistsViewModel.delete(id: id)
                    }
                }
                cell.cellConfiguration(events: item)
                return cell
                
            } else {
                
                let cellIdentifier = GistsAuthorsCollectionViewCell.identifier
                guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                               for: indexPath) as? GistsAuthorsCollectionViewCell else {
                                                                return UICollectionViewCell()}
                
                if !self.isPublic {
                    cell.deletionButton()
                    
                    cell.passingDeletion = {
                        guard let deletingIndexPath = self.collectionView.indexPath(for: cell) else { return }
                        
                        let id = self.gistsViewModel.authors.value[deletingIndexPath.row].id
                        self.gistsViewModel.deleteRequest(provider: self.moyaProvider, id: id)
                        self.gistsViewModel.delete(id: id)
                    }
                }
                cell.cellConfiguration(events: item)
                return cell
            }
        }
        
        if let eventDataSource = gistsViewModel?.datasource {
            gistsViewModel.authors
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
    }
    
    private func pullToRefresh() {
        let refresher = UIRefreshControl()
        refresher.tintColor = .black
        collectionView.refreshControl = refresher
        
        gistsViewModel.pullToRefresh(refresher: refresher,
                                     provider: moyaProvider,
                                     isPublic: isPublic)
    }
    
    // MARK: Jumping to new VC
    private func goToChooseFileVC(index: Int) {
        let data = gistsViewModel.authors.value[index]
        ShowControllers.showGistFilesOfAuthors(from: self, data: data)
    }
    
    private func gotoNewGistVC() {
        ShowControllers.showCreateNewGist(from: self)
    }
    
    // using custom segmented controll
    @IBAction func changingTheStatementInListGridSC(_ sender: SelectingListOrGridStateSegmentedControl) {
        switch sender.selectedSegmentIndex {
        case State.List.indexValue:
            isListFlowLayout = true
            
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(addingListCollectionLayout(),
                                                   animated: true) { [unowned self] (_) in
                self.collectionView.reloadData()
            }
            
        case State.Grid.indexValue:
            isListFlowLayout = false
            
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(addingGridCollectionLayout(),
                                                   animated: true) { [unowned self] (_) in
                self.collectionView.reloadData()
            }
            
        default:
            print("none")
        }
    }
    
    private func addingGridCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let colons: CGFloat = 2
        let minimumInteritemSpacing: CGFloat = 4
        let gridValue: CGFloat = ((width / colons) - minimumInteritemSpacing)
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: gridValue, height: gridValue)
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = 8
        
        return layout
    }
    
    private func addingListCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: view.frame.height / 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        return layout
    }
}
