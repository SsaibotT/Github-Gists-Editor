//
//  AccountFilesViewModel.swift
//  Github Gists Editor
//
//  Created by Serhii on 12/2/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

class AccountFilesViewModel {
    
    var attributedText: BehaviorRelay<NSAttributedString> = BehaviorRelay(value: NSAttributedString())
    
    init(text: URL) {
        getRequest(text: text)
    }
    
    private func getRequest(text: URL) {
        
        Alamofire.request(text).responseJSON { [weak self] response in
            
            guard let richText = try? NSAttributedString.init(data: response.data!, options: [NSAttributedString
                .DocumentReadingOptionKey
                .documentType: NSAttributedString.DocumentType.plain],
                                                              documentAttributes: nil) else { return print(Error.self)}
            
            self?.attributedText.accept(richText) 
        }
    }
}
