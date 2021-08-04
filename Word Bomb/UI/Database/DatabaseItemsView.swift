//
//  DatabaseItemsView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 29/7/21.
//

import SwiftUI
import CoreData

struct DatabaseItemsView: View {

    @Environment(\.editMode) var isEditing
    @ObservedObject var dbHandler: DatabaseHandler
    
    init(dbHandler: DatabaseHandler, dbName: String, databases: FetchedResults<Database>) {
        print("initing itemsView")
        self.dbHandler = dbHandler
        
        self.dbHandler.setDB(db: databases.first(where: {$0.wrappedName == dbName})!)
    }

    var body: some View {
        
        VStack(spacing:15) {
            
            WordSearchBar(dbHandler: dbHandler)
            
            ScrollView {
                
                LazyVStack {
                    
                    NewWordButton(dbHandler: dbHandler)
                    NewWordsView(dbHandler: dbHandler)
                    
                    ForEach(dbHandler.prefix != nil ? dbHandler.prefixWords : dbHandler.filteredWords, id:\.self) { word in
                        VStack {
                            HStack {
                                if isEditing?.wrappedValue == .active  {
                                    if dbHandler.selectedWords.contains(word) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .renderingMode(.original)
                                            .foregroundColor(.blue)
                                            .imageScale(.large)
                                    } else {
                                        Image(systemName: "circle")
                                            .renderingMode(.template)
                                            .foregroundColor(.gray)
                                            .imageScale(.large)
                                    }
                                }
                                Text(word.capitalized)
                        
                            }
                            .frame(maxWidth: Device.width, maxHeight: 20, alignment:.leading)
                            .padding(.leading)
                            
                            Divider()
                        }
                        .onTapGesture {
                            dbHandler.toggleSelectedWord(word)
                            
                        }
                    }
                }
                .onChange(of: dbHandler.filter) { filter in dbHandler.updateFilter() }
//                .onAppear { dbHandler.initWords() }
                .resignKeyboardOnDragGesture()
            }
            .overlay(AlphabetScrollList(dbHandler: dbHandler))
            .navigationTitle(Text("Search"))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {

                    Button(action: {
                        withAnimation {
                            dbHandler.deleteWords()
                        }
                    }) {
                        Image(systemName: "trash")
                    }
                
                    EditButton()
                }
                
            }
            .ignoresSafeArea(.all)
        }
        .font(.system(.body, design: .rounded))
        
    }
}




struct DatabaseItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            DatabaseView(dbName: "country")
//            DatabaseView(database: Database(name: "Countries", words: Game.countries))
        }
    }
}
