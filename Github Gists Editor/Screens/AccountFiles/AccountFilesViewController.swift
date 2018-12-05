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
    
    private var accountFilesViewModel: AccountFilesViewModel!
    private var disposeBag = DisposeBag()
    private var text: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountFilesViewModel = AccountFilesViewModel(text: text)
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        accountFilesViewModel.attributedText
            .asObservable()
            .bind(to: fileText.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    func configurationVC(textPath: String) {
        text = URL(string: textPath)
    }
}
