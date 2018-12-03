//
//  ChooseFile.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class AccountInfo: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var filesTableView: UITableView!
    
    var accountInfoViewModel = AccountInfoViewModel()
    var disposeBag = DisposeBag()
    var nameAutor: String!
    var avatarAutor: URL!
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "AccountInfoCell", bundle: nil)
        filesTableView.register(nibName, forCellReuseIdentifier: AccountInfoCell.identifier)
        
        nameLabel.text = nameAutor
        avatarImage.kf.setImage(with: avatarAutor)
        
        settingAvatarImage()
        setupBindings()
    }
    
    func setupBindings() {
        accountInfoViewModel.fileNames
            .asObservable()
            .bind(to: filesTableView.rx
                .items(cellIdentifier: AccountInfoCell.identifier,
                       cellType: AccountInfoCell.self)) {(_, event, cell) in
                        cell.cellConfiguration(name: event)
                        
                        cell.passingAccountFileVcCall = { [unowned self] in
                            guard let index = self.filesTableView.indexPath(for: cell)?.row else { return }
                            self.goToChosenFileVC(index: index)
                        }
            }
            .disposed(by: disposeBag)
    }
    
    func settingAvatarImage() {
        avatarImage.layer.borderWidth = 1
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.borderColor = UIColor.black.cgColor
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        avatarImage.clipsToBounds = true
    }
    
    func configurationVC(event: Event) {
        self.event = event
        accountInfoViewModel.fileNames.accept(event.files.values.map {$0.filename})
        nameAutor = event.owner.login
        avatarAutor = URL(string: event.owner.avatarURL)
    }
    
    func goToChosenFileVC(index: Int) {
        let textPath = event.files.values.map {$0.rawURL}
        ShowControllers.showChosenFile(from: self, textPath: textPath[index])
    }
}