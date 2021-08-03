//
//  Word+CoreDataProperties.swift
//  Word Bomb
//
//  Created by Brandon Thio on 3/8/21.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var content: String?
    @NSManaged public var databases: NSSet?
    
    public var wrappedContent: String {
        content ?? "nil"
    }
    
    public var dbArray: [Database] {
        let set = databases as? Set<Database> ?? []
        
        return set.sorted { $0.wrappedName < $1.wrappedName }
    }
}

// MARK: Generated accessors for databases
extension Word {

    @objc(addDatabasesObject:)
    @NSManaged public func addToDatabases(_ value: Database)

    @objc(removeDatabasesObject:)
    @NSManaged public func removeFromDatabases(_ value: Database)

    @objc(addDatabases:)
    @NSManaged public func addToDatabases(_ values: NSSet)

    @objc(removeDatabases:)
    @NSManaged public func removeFromDatabases(_ values: NSSet)

}
