//
//  AddDatabaseView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 4/8/21.
//

import SwiftUI


struct SectionHeaderText: View {
    var text: String
    init(_ text: String) {
        self.text = text
    }
    var body: some View {
        Text(text)
            .foregroundColor(.gray)
            .font(.subheadline)
            .padding(.leading, 25)
    }
}
struct AddDatabaseView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Database.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Database.name, ascending: true)]) var databases: FetchedResults<Database>
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var dbName = ""
    
    @State private var alertIsPresented = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State var selection: Database?
    
    func addDatabase() {
        let name = dbName.trim().lowercased()
        if databases.map({$0.wrappedName}).contains(name) {
            showAlert(title: "Error saving database", message: "\(name.capitalized) already exists")
            dbName = ""
        } else if name == "" {
            showAlert(title: "Error saving database", message: "Invalid database name")
            dbName = ""
        } else {
            let newDB = Database(context: viewContext)
            newDB.name = name
            
            if let selectedDB = selection {
                for word in databases.first(where: {$0.wrappedName == selectedDB.wrappedName})!.wordsArray {
                    newDB.addToWords(word)
                }
            }
            
            do {
                try viewContext.save()
            } catch {
                showAlert(title: "Error saving database", message: String(describing: error))
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func showAlert(title: String, message: String) {
        alertIsPresented = true
        alertTitle = title
        alertMessage = message
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading) {
                SectionHeaderText("Database Name")
                
                TextField("Name", text: $dbName)
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    .padding(.horizontal, 20)
                
                List(selection: $selection) {
                    Text("Copy Existing")
                        .font(.system(.body, design: .rounded))
                    
                    ForEach(databases, id: \.self) { db in
                        Text(db.wrappedName.capitalized)
                        
                    }
                }
                .environment(\.editMode, .constant(EditMode.active))
            }
            
            .navigationTitle("Add Database")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { withAnimation{addDatabase()} } ) {
                        Text("Save")
                    }
                }
            }
        }
        .banner(isPresented: $alertIsPresented, title: alertTitle, message: alertMessage)
    }
}

struct AddDatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        AddDatabaseView()
    }
}
