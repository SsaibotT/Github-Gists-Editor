//
//  AccountInfoViewModel.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/30/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountInfoViewModel {
    
    var fileNames: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
}
