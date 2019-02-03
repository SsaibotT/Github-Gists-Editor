//
//  GistsAutorsCollectionViewCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/27/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class GistsAutorsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filesCountLabel: UILabel!

    var passingDeletion: (() -> Void)?
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImage.layer.cornerRadius = 10
        avatarImage.clipsToBounds = true
        
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
    
    func deletionButton() {
        let deletingButtonRect = CGRect.init(x: 8, y: 8, width: 20, height: 20)
        let deleteButton = UIButton(frame: deletingButtonRect)
        deleteButton.setImage(UIImage.init(named: "closeIcon"), for: .normal)
        self.addSubview(deleteButton)
        
        deleteButton.rx.tap
            .asObservable()
            .subscribe({ [unowned self] (_) in
                if let callingDelete = self.passingDeletion {
                    callingDelete()
                }
            }).disposed(by: disposeBag)
    }
}
