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
    @IBOutlet weak var pickTypeOfText: UITextField!
    
    let moyaProvider = APIProvider.provider()
    
    var createNewGistViewModel: CreateNewGistViewModel!
    let disposeBag = DisposeBag()
    var selectedType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewGistViewModel = CreateNewGistViewModel()
        
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.black.cgColor
        
        creatingPickerView()
        createToolbar()
    }
    
    func creatingPickerView() {
        let typePicker = UIPickerView()
        
        createNewGistViewModel.types.bind(to: typePicker.rx.itemTitles) { (_, element) in
            return element
            }
            .disposed(by: disposeBag)
        
        typePicker.rx.itemSelected
            .subscribe (onNext: { [unowned self] (row, _) in
                self.selectedType = self.createNewGistViewModel.types.value[row]
                self.pickTypeOfText.text = self.selectedType
            })
            .disposed(by: disposeBag)
        
        pickTypeOfText.inputView = typePicker
    }
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(CreateNewGistViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        pickTypeOfText.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func creatingGistButton(_ sender: UIButton) {
        createNewGistViewModel.getRequest(provider: moyaProvider,
                                          fileName: fileNameTextField.text!,
                                          selectedType: selectedType,
                                          content: contentTextView.text)
    }
    
    @IBAction func isPublic(_ sender: UISegmentedControl) {
        createNewGistViewModel.isPublic(segmentedControl: sender)
    }
}
