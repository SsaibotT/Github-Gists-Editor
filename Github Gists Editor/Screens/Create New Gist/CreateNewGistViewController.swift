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
import PKHUD

class CreateNewGistViewController: UIViewController {

    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var pickTypeOfText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var isPublicSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomSecretConstraint: NSLayoutConstraint!
    @IBOutlet weak var dismissViewControllerButton: UIButton!
    
    private let moyaProvider = APIProvider.provider()
    
    private var createNewGistViewModel: CreateNewGistViewModel!
    let disposeBag = DisposeBag()
    private var normalSizeOfConstraint: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewGistViewModel = CreateNewGistViewModel(tapButton: uploadButton.rx.tap.asObservable(),
                                                        provider: moyaProvider,
                                                        viewController: self)
                                                    
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.black.cgColor
        
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.borderColor = UIColor.black.cgColor
        uploadButton.layer.cornerRadius = 10
        uploadButton.clipsToBounds = true
        
        creatingPickerView()
        createToolbar()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        normalSizeOfConstraint = bottomSecretConstraint.constant
        keyboardRxNotifications()
    }
    
    func keyboardRxNotifications() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .asObservable()
            .subscribe(onNext: { [unowned self] (notification) in
                guard let userInfo = notification.userInfo else { return }
                
                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
                
                let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
                    as? NSNumber)?.doubleValue ?? 0
                
                let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
                
                self.bottomSecretConstraint.constant = -endFrame.height / 1.5 //Cause without devide it is higher =)
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .asObservable()
            .subscribe(onNext: { [unowned self] (notification) in
                guard let userInfo = notification.userInfo else { return }
                
                let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
                    as? NSNumber)?.doubleValue ?? 0
                
                let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
                
                self.bottomSecretConstraint.constant = self.normalSizeOfConstraint
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            })
            .disposed(by: disposeBag)
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
        
        dismissViewControllerButton.rx.tap
            .asObservable()
            .subscribe({ [unowned self] (_) in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        createNewGistViewModel
            .uploadButtonResult
            .subscribe(onNext: { [unowned self] (success) in
                if success {
                    // 1.5 is for waiting when HUD.flash(success, delay:1) ends
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true)
                    }
                } else {
                    HUD.hide(afterDelay: 1.0)
                    let message = "Some fields are empty, you need to provide more information"
                    let alert = UIAlertController(title: "Error",
                                                  message: message,
                                                  preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
            .bind(to: typePicker.rx.itemTitles) { [unowned self] (_, element) in
                if self.pickTypeOfText.text == "" {
                    self.pickTypeOfText.text = ".txt"
                }
                return element
            }
            .disposed(by: disposeBag)
        
        typePicker.rx.itemSelected
            .subscribe (onNext: { [unowned self] (row, _) in
                self.pickTypeOfText.text = self.createNewGistViewModel.types.value[row]
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
