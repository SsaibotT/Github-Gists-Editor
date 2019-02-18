//
//  GistsAutorsListCollectionViewCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/29/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class GistsAuthorsListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filesCountLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var authorInfoButton: UIButton!
    
    
    
    var passingDeletion: (() -> Void)?
    var passingAuthorInfo: (() -> Void)?
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImage.layer.cornerRadius = 10
        avatarImage.clipsToBounds = true
        authorInfoButtonTapped()
    }
    
    func cellConfiguration(events: Event) {
        
        if let avatarURL = events.owner?.avatarURL {
            avatarImage.kf.setImage(with: URL(string: avatarURL))
        } else {
            avatarImage.image = Image(named: "questionMark")
        }
        
        nameLabel.text = events.owner?.login ?? "unknown"
        
        filesCountLabel.text = "\(events.files.count)"
    }
    
    func authorInfoButtonTapped() {
        authorInfoButton.rx.tap
            .asObservable()
            .subscribe({ [unowned self] (_) in
                self.passingAuthorInfo?()
            })
            .disposed(by: disposeBag)
    }
    
    func deletionButton() {
        let deletingButtonRect = CGRect.init(x: mainView.frame.width - 60,
                                             y: mainView.frame.height / 2.5,
                                             width: 50,
                                             height: 50)
        
        let deleteButton = UIButton(frame: deletingButtonRect)
        deleteButton.setImage(UIImage(named: "trash"), for: .normal)
        self.contentView.addSubview(deleteButton)
        
        deleteButton.rx.tap
            .asObservable()
            .subscribe({ [unowned self] (_) in
                self.passingDeletion?()
            }).disposed(by: disposeBag)
    }

}
