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

class GistsAuthorsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filesCountLabel: UILabel!
    
    var passingDeletion: (() -> Void)?
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor,
                                UIColor.black.withAlphaComponent(1.0).cgColor]
        //gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = avatarImage.frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        avatarImage.layer.insertSublayer(gradientLayer, at: 0)
        //avatarImage.layer.cornerRadius = 10
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
        deleteButton.setImage(UIImage.init(named: "close"), for: .normal)
        self.addSubview(deleteButton)
        
        deleteButton.rx.tap
            .asObservable()
            .subscribe({ [unowned self] (_) in
                self.passingDeletion?()
            }).disposed(by: disposeBag)
    }
}
