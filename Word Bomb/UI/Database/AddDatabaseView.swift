//
//  AddDatabaseView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 4/8/21.
//

import SwiftUI

struct AddDatabaseView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Database.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Database.name, ascending: true)]) var databases: FetchedResults<Database>
    
    @State var dbName = ""
    
    func addDatabase() {
        let newDB = Database(context: viewContext)
        newDB.name = "country 1"
        for word in databases.first(where: {$0.wrappedName == "country"})!.wordsArray {
            newDB.addToWords(word)
        }
        try! viewContext.save()
        
    }
    
    var body: some View {
        Form {
            Section(header: Text("Database Name")) {
                TextField("Enter the name of your database", text: $dbName)
            }
        }
    }
}

struct AddDatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        AddDatabaseView()
    }
}
