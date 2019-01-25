//
//  GistsAutorsTableViewCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Kingfisher

class GistsAutorsTableViewCell: UITableViewCell {

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
        
        if let login = events.owner?.login {
            nameLabel.text = login
        } else {
            nameLabel.text = "unknown"
        }

        filesCountLabel.text = "\(events.files.count)"
    }
}
