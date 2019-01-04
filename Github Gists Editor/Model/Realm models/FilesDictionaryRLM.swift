//
//  FilesDictionaryRLM.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/4/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class FilesDictionaryRLM: Object {
    @objc dynamic var name = ""
    let file = List<FileRLM>()
}
