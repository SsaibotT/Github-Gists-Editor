//
//  ChosenFileViewController.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/28/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

class AccountFiles: UIViewController {

    @IBOutlet weak var fileText: UITextView!
    
    var accountFilesViewModel: AccountFilesViewModel!
    var disposeBag = DisposeBag()
    var text: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountFilesViewModel = AccountFilesViewModel(text: text)
        setupSubscribers()
    }
    
    func setupSubscribers() {
        accountFilesViewModel.attributedText
            .asObservable()
            .subscribe(onNext: { [unowned self] (value) in
                self.fileText.attributedText = value
            })
            .disposed(by: disposeBag)
    }
    
    func configurationVC(textPath: String) {
        text = URL(string: textPath)
    }
}
