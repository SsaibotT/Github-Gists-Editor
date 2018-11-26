//
//  ActorTableViewCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Kingfisher

class ActorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func cellConfiguration(image: URL, name: String) {
        nameLabel.text = name
        avatarImage.kf.setImage(with: image)
    }
}
