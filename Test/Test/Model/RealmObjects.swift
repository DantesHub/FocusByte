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
    @objc dynamic var deepFocusMode = true
    @objc dynamic var hair: String? = nil
    @objc dynamic var eyes: String? = nil
    @objc dynamic var skin: String? = nil
    @objc dynamic var shirt: String? = nil
    @objc dynamic var pants: String? = nil
    @objc dynamic var shoes: String? = nil

    var inventoryArray = List<String>()
    override static func primaryKey() -> String? {
        return "email"
    }
}

class Tag: Object {
   @objc dynamic var name = ""
   @objc dynamic var color = ""
   @objc dynamic var selected  = false
    
    convenience init(name: String, color: String, selected: Bool) {
        self.init()
        self.name = name
        self.color = color
        self.selected = selected
    }
    
}
extension Tag {
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color
    }
}

extension User {
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: .modified)
        }
    }
}
