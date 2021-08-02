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
    @State var words: [Word] = []
    @State private var isLoading = false
    @State var searchText = ""
    
    @State var index: [String:String] = [:]
    init(dbName: String) {
        self.dbName = dbName
        print("Viewing database: \(dbName)")
    }
    func fetchSearchResults() {
        
        viewContext.perform {
            
            isLoading = true
            
            let request: NSFetchRequest<Word> = Word.fetchRequest()
            let db = databases.first(where: {$0.wrappedName == dbName})!
            
            request.predicate = searchText == "" ? NSPredicate(format: "database == %@", db) : NSPredicate(format:"content CONTAINS[c] %@ AND database == %@", searchText, db)
            print("selected database \(db)")
//            request.fetchBatchSize = 100
            
            // sort words
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \Word.content, ascending: true)
            ]
            
            words = try! viewContext.fetch(request)

            for word in words {
                let letter = String((word.wrappedContent.first)!)
                
                if index[letter] == nil {
                    index[letter] = word.wrappedContent
//                    print("first word \(index[letter]!) found for \(letter)")
                }
            }
            print(index)
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
            
            DatabaseItemsView(index: index, words: words)
        }
        
        .onChange(of: searchText, perform: {text in fetchSearchResults()})
//        .onAppear { fetchSearchResults() }
        
        
    }
}

struct DatabaseItemsView: View {
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y", "z"]
    var index: [String:String] = [:]
    var words: [Word]
    
    var body: some View {
        ScrollViewReader { value in
            ZStack {
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(words) { word in
                            VStack {
                                Text(word.wrappedContent.capitalized)
                                    .frame(maxWidth: Device.width, maxHeight: 20, alignment:.leading)
                                    .padding(.leading)
                                    .font(.system(.body, design: .rounded))
                                Divider()
                            }
                           .id(word)
                        }
                    }
                    .resignKeyboardOnDragGesture()
                }
                
                .overlay(
                    HStack {
                        Spacer()
                        VStack {
                            ForEach(alphabet, id: \.self) { letter in
                                Button(letter.uppercased()) {
                                    withAnimation {
                                        value.scrollTo(index[letter, default: "$"], anchor: .top)
                                        print("scrolling to \(index[letter, default: "$"]) for letter \(letter)")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.trailing)
                )
                .navigationTitle(Text("Search"))
                .ignoresSafeArea(.all)
            }
            
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
