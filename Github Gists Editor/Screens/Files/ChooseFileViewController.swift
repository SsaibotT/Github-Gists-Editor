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
import Kingfisher

class ChooseFileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var filesTableView: UITableView!
    
    var fileNames: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var disposeBag = DisposeBag()
    var nameAutor: String!
    var avatarAutor: URL!
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "ChooseFileCell", bundle: nil)
        filesTableView.register(nibName, forCellReuseIdentifier: "ChooseFileCell")
        
        nameLabel.text = nameAutor
        avatarImage.kf.setImage(with: avatarAutor)
        setupBindings()
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
        
        filesTableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in
                self.goToChosenFileVC(index: $0.row)
            })
            .disposed(by: disposeBag)
    }
    
    func configurationVC(event: Event) {
        self.event = event
        fileNames.accept(event.files.values.map {$0.filename})
        nameAutor = event.owner.login
        avatarAutor = URL(string: event.owner.avatarURL)
    }
    
    func goToChosenFileVC(index: Int) {
        let textPath = event.files.values.map {$0.rawURL}
        ShowControllers.showChosenFile(from: self, textPath: textPath[index])
    }
}
