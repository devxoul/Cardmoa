//
//  Card.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import Foundation

class Card {
    var name: String = ""
    var memo: String = ""
    var imagePath: String = ""

    var dictionaryValue: [String: AnyObject] {
        return [
            "name": self.name,
            "memo": self.memo,
            "imagePath": self.imagePath,
        ]
    }

    convenience init(dictionary: [String: AnyObject]) {
        self.init()
        self.name = dictionary["name"]!.stringValue
        self.memo = dictionary["memo"]!.stringValue
        self.imagePath = dictionary["imagePath"]!.stringValue
    }
}
