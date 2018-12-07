//
//  ShowControllers.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import UIKit

class ShowControllers {
    
    static func showGistFilesOfAutors(from viewController: UIViewController, data: Event) {
        
        let identifier = AccountInfo.identifier
        if let filesVC = viewController.storyboard?
            .instantiateViewController(withIdentifier: identifier) as? AccountInfo {
            filesVC.hidesBottomBarWhenPushed = true
            filesVC.configurationVC(event: data)
            viewController.navigationController?.show(filesVC, sender: viewController)
        }
    }
    
    static func showChosenFile(from viewController: UIViewController, textPath: String) {
        
        let identifier = AccountFiles.identifier
        if let fileVC = viewController.storyboard?
            .instantiateViewController(withIdentifier: identifier) as? AccountFiles {
            fileVC.hidesBottomBarWhenPushed = true
            fileVC.configurationVC(textPath: textPath)
            viewController.navigationController?.show(fileVC, sender: viewController)
        }
    }
    
    static func showCreateNewGist(from viewController: UIViewController) {
        let identifier = CreateNewGistViewController.identifier
        if let newGistVC = viewController.storyboard?
            .instantiateViewController(withIdentifier: identifier) as? CreateNewGistViewController {
            viewController.navigationController?.show(newGistVC, sender: viewController)
        }
    }
}
