//
//  ChosenFileViewController.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/28/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Alamofire

class ChosenFileViewController: UIViewController {

    @IBOutlet weak var fileText: UITextView!
    
    var text: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRequest()
    }
    
    func getRequest() {
        Alamofire.request(text).responseJSON { response in
            
            guard let richText = try? NSAttributedString.init(data: response.data!, options: [NSAttributedString
                .DocumentReadingOptionKey
                .documentType: NSAttributedString.DocumentType.plain],
                                                              documentAttributes: nil) else { return print(Error.self)}
            self.fileText.attributedText = richText
        }
    }
    
    func configurationVC(textPath: String) {
        self.text = URL(string: textPath)
    }
}
