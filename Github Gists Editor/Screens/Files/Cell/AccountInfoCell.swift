//
//  ChooseFileCell.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

class AccountInfoCell: UITableViewCell {

    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var fileNameLabel: UILabel!
    var passingAccountFileVcCall: (() -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundView.layer.cornerRadius = 10
        roundView.layer.masksToBounds = false
        roundView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        roundView.layer.shadowColor = UIColor.black.cgColor
        roundView.layer.shadowOpacity = 1
        roundView.layer.shadowRadius = 4
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self.contentView)
        let view = self.contentView.hitTest(point, with: event)
        
        if view != self.contentView {
            passingAccountFileVcCall()
        }
    }
    
    func cellConfiguration(name: String) {
        fileNameLabel.text = name
    }
}
