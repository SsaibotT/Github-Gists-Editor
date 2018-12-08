//
//  CreateNewGistViewController.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/6/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Foundation
import Moya
import RxCocoa
import RxSwift

class CreateNewGistViewController: UIViewController {

    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    let moyaProvider = APIProvider.provider()
    var typeText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeText = ".txt"
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func creatingGistButton(_ sender: UIButton) {

        MoyaCreateGistEndPoint.description = fileNameTextField.text!
        MoyaCreateGistEndPoint.fileName += typeText
        MoyaCreateGistEndPoint.content  = contentTextView.text
        
        moyaProvider.request(MultiTarget.target(MoyaCreateGistEndPoint.createUser)) { response in
            switch response {
            case .success(let result):
                print(result.data)
            default:
                print("some")
            }
        }
    }
    
    @IBAction func chooseFileTypeSegmentedController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            typeText = ".txt"
        } else {
            typeText = ".html"
        }
    }
    
    @IBAction func isPublic(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            MoyaCreateGistEndPoint.isPublic = true
        } else {
            MoyaCreateGistEndPoint.isPublic = false
        }
    }
}
