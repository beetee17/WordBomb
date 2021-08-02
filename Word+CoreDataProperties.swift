//
//  Word+CoreDataProperties.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/8/21.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var content: String?
    @NSManaged public var database: Database?
    public var wrappedContent: String {
        content ?? "nil"
    }
}
