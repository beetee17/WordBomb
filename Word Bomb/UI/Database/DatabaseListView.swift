//
//  DatabaseListView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 4/8/21.
//

import SwiftUI

struct LazyNavigationView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
struct DatabaseListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Database.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Database.name, ascending: true)]) var databases: FetchedResults<Database>
    @State var presentAddDBSheet = false
    @StateObject var dbHandler = DatabaseHandler()
    
    func deleteDB(at offsets: IndexSet) {
        viewContext.perform {
            for index in offsets {
                viewContext.delete(databases[index])
            }
            try! viewContext.save()
        }
    }
    
    func duplicateDB(_ db: Database) {
        viewContext.perform {
            let newDB = Database(context: viewContext)
            newDB.name = "\(db.wrappedName) Copy"
            for word in db.wordsArray {
                newDB.addToWords(word)
            }
            try! viewContext.save()
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(databases, id:\.self) { db in
                    NavigationLink(
                        destination: LazyNavigationView(DatabaseItemsView(dbHandler: dbHandler, dbName: db.wrappedName, databases: databases)),
                        label: {
                            Text("\(db.wrappedName.capitalized)")
                                .contextMenu {
                                    Button(action: {duplicateDB(db)}) {
                                        HStack {
                                            Text("Duplicate")
                                            Image(systemName: "plus.square.fill.on.square.fill")
                                            
                                        }
                                    }
                                }
                        })
                    
                }
                .onDelete(perform: { offsets in deleteDB(at: offsets) })
                
            }
            .id(UUID())
            .navigationTitle(Text("Databases"))
            .sheet(isPresented: $presentAddDBSheet, content: { AddDatabaseView() })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: { presentAddDBSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
        .banner(isPresented: $dbHandler.showAlert, title: dbHandler.alertTitle, message: dbHandler.alertMessage)
    }
}

struct DatabaseListView_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseListView()
    }
}
