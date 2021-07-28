//
//  DatabaseView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 29/7/21.
//

import SwiftUI

struct DatabaseListView: View {
    let databases = [Database(name: "Words", words: Game.dictionary), Database(name: "Countries", words: Game.countries)]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(databases) { database in
                    
                    NavigationLink(destination: DatabaseView(database: database)) {
                        Text(database.name)
                    }
                    
                }
            }
            .navigationTitle(Text("Databases"))
        }
    }
}
extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
struct DatabaseView: View {
    let database: Database
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var filteredDatabase: [String] = []
    private func searchDatabase(_ searchText: String) -> [String] {
        database.words.filter{$0.contains(searchText.trim().lowercased()) || searchText == ""}
    }
    
    var body: some View {
        
        VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            filteredDatabase = searchDatabase(searchText)
                            print("onCommit")
                        }).foregroundColor(.primary)
                        
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                    if showCancelButton  {
                        Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.searchText = ""
                            self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
            
                List {
                    // Filtered list of names
                    ForEach(filteredDatabase, id:\.self) {
                        searchText in Text(searchText.capitalized)
                    }
                }
                .id(UUID())
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text("Search"))
                .resignKeyboardOnDragGesture()
        }
    }
}

struct DatabaseListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DatabaseListView()
            DatabaseView(database: Database(name: "Countries", words: Game.countries))
        }
    }
}
