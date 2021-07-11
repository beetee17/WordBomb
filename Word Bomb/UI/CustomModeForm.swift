//
//  CustomModeForm.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI

struct CustomModeForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State private var gameType = "EXACT"
    @State private var modeName = ""
    @State private var words = ""
    @State private var queries = ""
    @State private var instruction = ""
    
    
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
            Section(header: Text("Instruction")) {
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
            

            Button("Save changes") {
                addItem(modeName: modeName, words: words, queries: queries, instruction: instruction, gameType: gameType)
            }
        }
    }
    
    private func addItem(modeName: String, words: String, queries: String, instruction: String, gameType: String) {
        withAnimation {
            do {
                let newItem = Item(context: viewContext)
                newItem.name = modeName
                let wordsData = words.components(separatedBy: "\n")
                newItem.words = encodeStrings(wordsData.map {
                    $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
               })
                print(newItem.words!)
                newItem.gameType = gameType
                
                let queryData = queries.components(separatedBy: "\n")
                newItem.queries = encodeStrings(queryData.map {
                    $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
               })
                
                newItem.instruction = instruction
                
                try viewContext.save()
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
