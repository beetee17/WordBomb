//
//  DatabaseView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 29/7/21.
//

import SwiftUI
import CoreData

struct LazyNavigationLink<Content: View>: View {
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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(databases, id:\.self) { db in
                    NavigationLink(
                        destination: LazyNavigationLink(DatabaseView(dbName: db.wrappedName)),
                        label: {
                            Text("\(db.wrappedName.capitalized)")
                        })
                    
                }
            }
            .onAppear() { print(databases)}
            .navigationTitle(Text("Databases"))
        }
    }
}

struct DatabaseView: View {
    var dbName: String
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y", "z"]
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Database.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Database.name, ascending: true)]) var databases: FetchedResults<Database>
    
    @State private var isLoading = false
    @State private var searchText = ""
    @State private var prevFilter = ""
    @State private var prefix: String? = nil
    
    @State private var words: [String] = []
    @State private var filteredWords: [String] = []
    
    @State private var index: [String:String] = [:]
    
    func getWords() {
        // performs an initial fetch to get load words in the database to memory as an array
        viewContext.perform {
            
            isLoading = true
            
            let request: NSFetchRequest<Word> = Word.fetchRequest()
            let db = databases.first(where: {$0.wrappedName == dbName})!
            
            request.predicate = NSPredicate(format: "database == %@", db)
            print("selected database \(db)")
            //            request.fetchBatchSize = 100
            
            // sort words
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \Word.content, ascending: true)
            ]
            
            words = try! viewContext.fetch(request).map({$0.wrappedContent})
            filteredWords = words
            
            for word in filteredWords {
                let letter = String((word.first)!)
                
                if index[letter] == nil {
                    index[letter] = word
                }
            }
            print(index)
            isLoading = false
        }
    }
    
    
    func updateFilter() {
        // in memory filtering instead of repeated fetching from core data
        // can be optimised by checking if filter was appended to (if so, can filter on subset of words)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let filter = searchText.trim().lowercased()
            
            isLoading = true
            var newWords:[String] = []
            var newIndex:[String:String] = [:]
            
            print("\(filter) starts with \(prevFilter) \(filter.starts(with: prevFilter))")
            
            if filter.starts(with: prevFilter) && prevFilter != "" {
                print("going the short route")
                for word in filteredWords {
                    if word.contains(filter) {
                        newWords.append(word)
                        let prefix = String(word.first!)
                        if newIndex[prefix] == nil {
                            newIndex[prefix] = word
                        }
                    }
                }
            } else {
                print("going the long route")
                for word in words {
                    if filter == "" || word.contains(filter) {
                        newWords.append(word)
                        let prefix = String(word.first!)
                        if newIndex[prefix] == nil {
                            newIndex[prefix] = word
                        }
                    }
                }
            }
            
            if filter == searchText.trim().lowercased() {
                // by the end of the loop the user may have entered a new search query
                // only return the results of the latest query
                filteredWords = newWords
                index = newIndex
                prevFilter = filter
            }
            isLoading = false
        }
    }
    
    
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $searchText)
                    .foregroundColor(.primary)
                
                if isLoading {
                    ProgressView()
                }
                Button(action: {
                    searchText = ""
                    
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            
            ScrollView {
                
                LazyVStack {
                    
                    ForEach(prefix != nil ? filteredWords.filter({$0.starts(with: prefix!)}) : filteredWords, id:\.self) { word in
                        VStack {
                            Text(word.capitalized)
                                .frame(maxWidth: Device.width, maxHeight: 20, alignment:.leading)
                                .padding(.leading)
                                .font(.system(.body, design: .rounded))
                            Divider()
                        }
                        .id(word)
                    }
                }
                .onChange(of: searchText) { filter in updateFilter() }
                .onAppear { getWords() }
                .resignKeyboardOnDragGesture()
            }
            .overlay(
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        ForEach(alphabet, id: \.self) { letter in
                            Button(letter) {
                                withAnimation {
                                    prefix = prefix == letter ? nil : letter
                                }
                            }
                            .textCase(.uppercase)
                            .foregroundColor(.blue)
                            .frame(width: 22, height: 22) // for drawing of background
                            .background(prefix == letter ? Color.gray.opacity(0.3) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                            .frame(width: 75, height: 25) // button tappable region
                        }
                    }
                }
            )
            .navigationTitle(Text("Search"))
            .ignoresSafeArea(.all)
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

//struct DatabaseListView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            DatabaseListView()
//            DatabaseView(database: Database(name: "Countries", words: Game.countries))
//        }
//    }
//}
