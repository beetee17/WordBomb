//
//  Database+CoreDataProperties.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/8/21.
//
//

import Foundation
import CoreData


extension Database {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Database> {
        return NSFetchRequest<Database>(entityName: "Database")
    }

    @NSManaged public var name: String?
    @NSManaged public var words: NSSet?
    
    public var wrappedName: String {
        name ?? "Untitled Database"
    }
    public var wordsArray: [Word] {
        let set = words as? Set<Word> ?? []
        
        return set.sorted { $0.wrappedContent < $1.wrappedContent }
    }
}

// MARK: Generated accessors for words
extension Database {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}
