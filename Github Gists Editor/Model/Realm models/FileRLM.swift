//
//  FileRLM.swift
//  Github Gists Editor
//
//  Created by Serhii on 1/4/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class FileRLM: Object {
    @objc dynamic var filename = ""
    @objc dynamic var rawURL = ""
}
