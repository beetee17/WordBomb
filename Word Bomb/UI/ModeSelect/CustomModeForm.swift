//
//  CustomModeForm.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI

enum EmptyFieldAlertType {
    case modeName, words, queries
}

struct CustomModeForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State private var gameType = "EXACT"
    @State private var modeName = ""
    @State private var words = ""
    @State private var queries = ""
    @State private var instruction = ""
    
    @State private var showSaveSuccessAlert = false
    @State private var showEmptyFieldAlert = false
    @State private var emptyFieldAlertType: EmptyFieldAlertType = .modeName
    
    var body: some View {
        Form {
            Section(header: Text("Game Mode")) {
                Picker("Select a color", selection: $gameType) {
                    ForEach(Defaults.gameTypes, id: \.0) { typeName, gameType in
                        Text(typeName)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("Mode Name")) {
                TextField("Enter the name of your mode", text: $modeName)
            }
            Section(header: Text("Instruction"))  {
                TextField("Enter user instruction here", text: $instruction)
                
            }
            
            
            Section(header: Text("Words")) {
                
                ZStack {
                    TextEditor(text: $words)
                }
            }
            
            if gameType == "CONTAINS" {
                Section(header: Text("Queries")) {
                    
                    ZStack {
                        TextEditor(text: $queries)
                    }
                }
            }
            

            Button(action: {
                addItem(modeName: modeName, words: words, queries: queries, instruction: instruction, gameType: gameType)
                
            })
            {
                HStack {
                    Text("Save Changes")
                    Spacer()
                    Image(systemName: "checkmark.circle")
                }
            }
            
            .alert(isPresented: $showEmptyFieldAlert) {
                switch emptyFieldAlertType {
                    
                case .modeName:
                    return Alert(title: Text("Empty Mode Name"),
                          message: Text("Please enter a name for your custom mode."),
                          dismissButton: .default(Text("OK")) {
                                                                print("dismissed")
                                                                showEmptyFieldAlert = false
                        
                    })
                case .words:
                    return Alert(title: Text("No Words Added"),
                          message: Text("Please enter some words to have fun."),
                          dismissButton: .default(Text("OK")) {
                                                                print("dismissed")
                                                                showEmptyFieldAlert = false
                        
                    })
                case .queries:
                    return Alert(title: Text("No Queries Added"),
                          message: Text("Please enter at least one query."),
                          dismissButton: .default(Text("OK")) {
                                                                print("dismissed")
                                                                showEmptyFieldAlert = false
                        
                    })
                }
            }
        }
        .alert(isPresented: $showSaveSuccessAlert) {
            return Alert(title: Text("Save Successful"),
                  message: Text("You can now find your new custom mode in the mode select view!."),
                  dismissButton: .default(Text("OK")) {
                print("dismissed")
                showSaveSuccessAlert = false

                })
        }
        
    }
    
    private func addItem(modeName: String, words: String, queries: String, instruction: String, gameType: String) {
        
        if modeName.trim() == "" {
            showEmptyFieldAlert = true
            emptyFieldAlertType = .modeName
            
        }
        
        else if words.trim() == "" {
            showEmptyFieldAlert = true
            emptyFieldAlertType = .words
            
        }
        
        else if queries.trim() == "" && gameType != "EXACT" {
            showEmptyFieldAlert = true
            emptyFieldAlertType = .queries
            
        }
        
        else {
            
            do {
                let newItem = Item(context: viewContext)
                newItem.name = modeName
                let wordsData = words.components(separatedBy: "\n")
                newItem.words = encodeStrings(wordsData.map {
                    $0.lowercased().trim()
               })
                print(newItem.words!)
                newItem.gameType = gameType
                
                let queryData = queries.components(separatedBy: "\n")
                newItem.queries = encodeStrings(queryData.map {
                    $0.lowercased().trim()
               })
                
                newItem.instruction = instruction
                
                
                try viewContext.save()
                showSaveSuccessAlert = true
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }
    }
}

struct CustomModeForm_Previews: PreviewProvider {
    static var previews: some View {
        CustomModeForm()
    }
}
