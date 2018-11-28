//
//  ChooseFileCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

class ChooseFileCell: UITableViewCell {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.y += 8
            frame.origin.x += 10
            frame.size.height -= 8
            frame.size.width  -= 2 * 10
            
            super.frame = frame
        }
    }

    @IBOutlet weak var fileNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func cellConfiguration(name: String) {
        fileNameLabel.text = name
    }
}
