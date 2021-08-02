//
//  Item+CoreDataProperties.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/8/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var gameType: String?
    @NSManaged public var instruction: String?
    @NSManaged public var name: String?
    @NSManaged public var queries: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var words: String?

}

extension Item : Identifiable {

}
