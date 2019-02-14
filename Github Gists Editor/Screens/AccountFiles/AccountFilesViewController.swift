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

class AccountFilesViewController: UIViewController {

    @IBOutlet weak var fileText: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var accountFilesViewModel: AccountFilesViewModel!
    private var disposeBag = DisposeBag()
    private var text: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountFilesViewModel = AccountFilesViewModel(text: text)
        setupSubscribers()
        setupBindings()
    }
    
    private func setupSubscribers() {
        accountFilesViewModel.attributedText
            .asObservable()
            .bind(to: fileText.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        closeButton.rx.tap
            .asObservable()
            .subscribe { [unowned self] _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configurationVC(textPath: String) {
        text = URL(string: textPath)
    }
}
