//
//  ChooseFile.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChooseFileViewController: UIViewController {

    @IBOutlet weak var filesTableView: UITableView!
    var fileNames: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "ChooseFileCell", bundle: nil)
        filesTableView.register(nibName, forCellReuseIdentifier: "ChooseFileCell")
    }
    
    func setupBindings() {
        fileNames
            .asObservable()
            .bind(to: filesTableView.rx
                .items(cellIdentifier: "ChooseFileCell",
                       cellType: ChooseFileCell.self)) {(_, event, cell) in
                        cell.cellConfiguration(name: event)
            }
            .disposed(by: disposeBag)
    }
    
    func configurationVC(event: Event) {
        fileNames.accept(event.files.values.map {$0.filename})
    }
}
