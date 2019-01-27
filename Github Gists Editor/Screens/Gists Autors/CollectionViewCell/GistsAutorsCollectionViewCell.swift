//
//  GistsAutorsCollectionViewCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/27/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import UIKit
import Kingfisher

class GistsAutorsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filesCountLabel: UILabel!
    
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
}
