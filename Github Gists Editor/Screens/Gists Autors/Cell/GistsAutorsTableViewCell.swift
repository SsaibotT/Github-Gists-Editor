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
        // Initialization code
    }
    
    func cellConfiguration(events: Event) {
        let image = URL(string: events.owner.avatarURL)
        
        nameLabel.text = events.owner.login
        avatarImage.kf.setImage(with: image)
        filesCountLabel.text = "\(events.files.values.count)"
    }
}
