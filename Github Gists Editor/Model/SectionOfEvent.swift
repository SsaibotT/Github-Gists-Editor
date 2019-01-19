//
//  SectionOfEvent.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/18/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfCustomData {
    var header: String
    var items: [Item]
}

extension SectionOfCustomData: AnimatableSectionModelType {
    typealias Item = Event
    typealias Identity = String
    
    var identity: String {
        return header
    }
    
    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}
