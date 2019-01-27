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
    
    private var accountInfoViewModel = AccountInfoViewModel()
    private var disposeBag = DisposeBag()
    private var nameAutor: String!
    private var avatarAutor: URL!
    private var event: Event!
    private var pictureIsAvaible: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "AccountInfoCell", bundle: nil)
        filesTableView.register(nibName, forCellReuseIdentifier: AccountInfoCell.identifier)
        
        nameLabel.text = nameAutor
        
        if pictureIsAvaible {
            avatarImage.kf.setImage(with: avatarAutor)
        } else {
            avatarImage.image = Image(named: "questionMark")
        }
        
        settingAvatarImage()
        setupBindings()
    }
    
    private func setupBindings() {
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
    
    private func settingAvatarImage() {
        avatarImage.layer.borderWidth = 1
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.borderColor = UIColor.black.cgColor
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        avatarImage.clipsToBounds = true
    }
    
    func configurationVC(event: Event) {
        self.event = event
        accountInfoViewModel.fileNames.accept(event.files.map { $0.filename })
        
        nameAutor = event.owner?.login ?? "unknown"
        
        if let avatarURL = event.owner?.avatarURL {
            avatarAutor = URL(string: avatarURL)
            pictureIsAvaible = true
        } else {
            pictureIsAvaible = false
        }
    }

    private func goToChosenFileVC(index: Int) {
        let textPath = event.files.map { $0.rawURL }
        ShowControllers.showChosenFile(from: self, textPath: textPath[index])
    }
}
