//
//  DatabaseView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 29/7/21.
//

import SwiftUI
import CoreData

struct DatabaseView: View {

    @Environment(\.editMode) var isEditing
    @ObservedObject var dbHandler: DatabaseHandler
    
    init(dbName: String, databases: FetchedResults<Database>) {

        dbHandler = DatabaseHandler(db: databases.first(where: {$0.wrappedName == dbName})!)
    }
    
    var body: some View {
        
        VStack {
            
            WordSearchBar(dbHandler: dbHandler)
            
            ScrollView {
                
                LazyVStack {
                    
                    
                    NewWordButton(dbHandler: dbHandler)
                    NewWordsView(dbHandler: dbHandler)
                    
                    ForEach(dbHandler.prefix != nil ? dbHandler.prefixWords : dbHandler.filteredWords, id:\.self) { word in
                        VStack {
                            HStack {
                                if isEditing?.wrappedValue == .active  {
                                    Image(systemName: dbHandler.selectedWords.contains(word) ? "checkmark.circle.fill" : "circle")
                                }
                                Text(word.capitalized)
                                    .frame(maxWidth: Device.width, maxHeight: 20, alignment:.leading)
                                    .padding(.leading)
                                    .font(.system(.body, design: .rounded))
                                
                            }
                            Divider()
                        }
                        .onTapGesture {
                            dbHandler.toggleSelectedWord(word)
                            
                        }
                    }
                }
                .onChange(of: dbHandler.filter) { filter in dbHandler.updateFilter() }
                .onAppear { dbHandler.initWords() }
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
        .banner(isPresented: $dbHandler.showAlert, title: dbHandler.alertTitle, message: dbHandler.alertMessage)
    }
}




struct DatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            DatabaseView(dbName: "country")
//            DatabaseView(database: Database(name: "Countries", words: Game.countries))
        }
    }
}
