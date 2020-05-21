//
//  RealmObjects.swift
//  Test
//
//  Created by Dante Kim on 4/9/20.
//  Copyright © 2020 Steve Ink. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var name: String? = nil
    @objc dynamic var gender: String? = nil
    @objc dynamic var email: String? = nil
    var timeArray = List<String>()
    var tagDictionary = List<Tag>()
    @objc dynamic var isLoggedIn = false
    @objc dynamic var coins = 0
    @objc dynamic var exp = 0 
    
    override static func primaryKey() -> String? {
        return "email"
    }
}

class Tag: Object {
   @objc dynamic var name = ""
   @objc dynamic var color = ""
    
}

extension User {
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: .modified)
        }
    }
}
