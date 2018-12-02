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

    let moyaProvider = MoyaProvider<MoyaGistsAutorsEndPoints>()

    var gistsViewModel: GistsAutorsViewModel!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = nil
        tableView.dataSource = nil
        
        let nibName = UINib(nibName: "GistsAutorsTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: GistsAutorsTableViewCell.identifier)
        
        gistsViewModel = GistsAutorsViewModel(provider: moyaProvider)
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBar()
    }
    
    func navigationBar() {

        let publicButton = UIBarButtonItem(title: "Public",
                                           style: .done,
                                           target: self,
                                           action: #selector(GistsAutorsTableViewController.publicButton))
        
        let privateButton = UIBarButtonItem(title: "Private",
                                            style: .done,
                                            target: self,
                                            action: #selector(GistsAutorsTableViewController.privateButton))
        
        let spacingButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        let arrayOfButtons = [publicButton, spacingButton, privateButton]
        toolbarItems = arrayOfButtons
    }
    
    @objc func publicButton() {
        
        gistsViewModel.getRequest(provider: moyaProvider, publicBool: true)
    }
    
    @objc func privateButton() {
        
        gistsViewModel.getRequest(provider: moyaProvider, publicBool: false)
    }
    
    func setupBindings() {
        
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
    
    func goToChooseFileVC(index: Int) {
        let data = gistsViewModel.actors.value[index]
        ShowControllers.showGistFilesOfAutors(from: self, data: data)
    }
}
