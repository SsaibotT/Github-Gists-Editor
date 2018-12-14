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
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var isPublicSegmentedControl: UISegmentedControl!
    
    private let moyaProvider = APIProvider.provider()
    
    private var createNewGistViewModel: CreateNewGistViewModel!
    let disposeBag = DisposeBag()
    private var selectedType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewGistViewModel = CreateNewGistViewModel()
        
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.black.cgColor
        
        creatingPickerView()
        createToolbar()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardFrameChangeNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardFrameChangeNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
            let endFrameY = endFrame.origin.y
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
                as? NSNumber)?.doubleValue ?? 0
            
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.view.frame.origin.y = 0
            } else {
                self.view.frame.origin.y -= endFrameY / 4
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    private func setupBindings() {
        fileNameTextField.rx.text
            .orEmpty
            .bind(to: createNewGistViewModel.fileName)
            .disposed(by: disposeBag)
        
        contentTextView.rx.text
            .orEmpty
            .bind(to: createNewGistViewModel.content)
            .disposed(by: disposeBag)
        
        pickTypeOfText.rx.text
            .orEmpty
            .bind(to: createNewGistViewModel.selectedType)
            .disposed(by: disposeBag)
        
//        createNewGistViewModel.isValid
//            .bind(to: uploadButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        uploadButton.rx.tap
            .subscribe({ [unowned self] (_) in
                if self.createNewGistViewModel.testValid {
                    self.createNewGistViewModel.getRequest(provider: self.moyaProvider)
                }
            })
            .disposed(by: disposeBag)
        
        isPublicSegmentedControl.rx.value
            .asObservable()
            .subscribe(onNext: { [unowned self] index in
                self.createNewGistViewModel.isPublic(index: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func creatingPickerView() {
        let typePicker = UIPickerView()
        
        createNewGistViewModel.types
            .bind(to: typePicker.rx.itemTitles) { (_, element) in
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
    
    private func createToolbar() {
        
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
