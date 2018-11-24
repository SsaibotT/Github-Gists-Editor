//
//  ActorTableViewCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

class ActorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func cellConfig(image: UIImage, name: String) {
        avatarImage.image = image
        nameLabel.text    = name
    }

}
