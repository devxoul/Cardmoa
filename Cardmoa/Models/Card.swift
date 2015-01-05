//
//  Card.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

let CardDidSaveNotification = "CardDidSaveNotification"
let CardDidDeleteNotification = "CardDidDeleteNotification"

class Card: NSObject, NSCopying {
    var id: String!
    var name: String!
    var memo: String!

    var image: UIImage? // cache
    var imagePath: String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String
        let filename = path.stringByAppendingPathComponent("\(self.id).png")
        return filename
    }

    var dictionaryValue: [String: AnyObject] {
        let dictionary = [
            "id": self.id,
            "name": self.name,
            "memo": self.memo,
        ]
        return dictionary
    }


    // MARK: - Initialize

    override init() {
        super.init()
        self.id = NSUUID().UUIDString
        self.name = ""
        self.memo = ""
    }

    convenience init(dictionary: [String: AnyObject]) {
        self.init()
        self.id = dictionary["id"] as String
        self.name = dictionary["name"] as String
        self.memo = dictionary["memo"] as String
    }


    // MARK: - NSCopying

    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Card()
        copy.id = self.id
        copy.name = self.name
        copy.memo = self.memo
        copy.image = self.image
        return copy
    }


    // MARK: - Image Operations

    func fetchImage(#success: (() -> ())?, failure: (() -> ())?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if let image = UIImage(contentsOfFile: self.imagePath) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.image = image
                    success?()
                })
            } else {
                // TODO: Error loading image from disk
                NSLog("[Card] Error loading image from disk: \(self.imagePath)")
                failure?()
            }
        })
    }

    func saveImage() {
        if let image = self.image {
            let data = UIImagePNGRepresentation(image)
            data.writeToFile(self.imagePath, atomically: true)
            NSLog("[Card] Save image at \(self.imagePath).")
        }
    }

    func deleteImage() {
        NSFileManager.defaultManager().removeItemAtPath(self.imagePath, error: nil)
    }


    // MARK: - Persistence

    class func fetchAll() -> [Card] {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.objectForKey("Cards") as? [[String: AnyObject]] {
            var cards: [Card]! = data.map { Card(dictionary: $0) }
            self.sort(&cards)
            NSLog("[Card] Fetch \(cards.count) cards.")
            return cards
        }
        NSLog("[Card] Fetch 0 cards.")
        return []
    }

    class func save(cards: [Card]) {
        let cards = cards.map { $0.dictionaryValue }
        NSUserDefaults.standardUserDefaults().setObject(cards, forKey: "Cards")
        NSUserDefaults.standardUserDefaults().synchronize()
        NSLog("[Card] Save \(cards.count) cards.")
    }


    // MARK - Utils

    class func sort(inout cards: [Card]!) {
        cards.sort {
            return $0.name < $1.name
        }
    }

}
