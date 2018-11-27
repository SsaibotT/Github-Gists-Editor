//
//  ActorTableViewCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Kingfisher

class ActorTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func cellConfiguration(events: Event) {
        let image = URL(string: events.actor.avatarURL)
        
        nameLabel.text = events.repo.name
        avatarImage.kf.setImage(with: image)
    }
}
