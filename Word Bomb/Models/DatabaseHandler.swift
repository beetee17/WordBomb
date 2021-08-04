//
//  DatabaseHandler.swift
//  Word Bomb
//
//  Created by Brandon Thio on 4/8/21.
//

import Foundation
import CoreData

class DatabaseHandler: ObservableObject {
    @Published var wordsToAdd = [WordToAdd]() // stores new word(s) that user would like to add
    @Published var isLoading = true // determines if ProgressView spinning circle should be displayed
    @Published var filter = ""
    @Published var prefix: String? = nil
    @Published var filteredWords = [String]() // stores a subset of words in the database that contains filter
    @Published var selectedWords = Set<String>() // stores the word(s) that user would like to delete
    
    var prevFilter = "" // for optimisation of search filter
    var words = [String]() // stores all words in the database

    var prefixWords: [String] {
        // computed property for when user selects a letter from the alphabet scroll view
        // called iff prefix != nil
        get { filteredWords.filter({$0.starts(with: prefix!)}) }
    }
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    var moc: NSManagedObjectContext
    var db: Database
    
    init(db: Database) {
        self.moc = privateContext
        self.db = db
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func initWords() {
        // performs an initial fetch to get load words in the database to memory as an array
        moc.perform { [self] in

            let request: NSFetchRequest<Word> = Word.fetchRequest()

            request.predicate = NSPredicate(format: "databases CONTAINS %@", db)
            //            request.fetchBatchSize = 100

            // sort words
            request.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(Word.content), ascending: true)
            ]
            
            do {
                let fetchedWords = try moc.fetch(request).map({$0.wrappedContent})
                
                print("\(fetchedWords.count) items in the database")

                DispatchQueue.main.async {
                    print("initing words")
                    filteredWords = fetchedWords
                    isLoading = false
                    words = filteredWords
                }
            } catch {
                showAlert(title: "Error loading words ", message: String(describing: error))
            }
        }
        
    }
    
    func updateFilter() {
        // in memory filtering instead of repeated fetching from core data
        // can be optimised by checking if filter was appended to (if so, can filter on subset of words)
        print("filtering words")
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            
            let filterText = filter.trim().lowercased()
            // maintain a copy of filter to check that user has not updated it before mutating filteredWords
            
            DispatchQueue.main.async {
                isLoading = true
            }
            
            var newWords:[String] = []
            
            print("\(filter) starts with \(prevFilter) \(filter.starts(with: prevFilter))")

            if filterText.starts(with: prevFilter) && prevFilter != "" {
                // optimised search if the current filter has a prefix of the prevFilter (thus all search results should be a subset of the current results)
                print("going the short route")
                for word in filteredWords {
                    if word.contains(filterText) {
                        newWords.append(word)
                    }
                }
            } else {
                print("going the long route")
                for word in words {
                    if filterText == "" || word.contains(filterText) {
                        newWords.append(word)
                    }
                }
            }
            
            DispatchQueue.main.async {
                if filterText == filter.trim().lowercased() {
                    // by the end of the loop the user may have entered a new search query
                    // only return the results of the latest query
                    print("updated words")
                    filteredWords = newWords
                    prevFilter = filterText
                }
                isLoading = false
            }
            
        }
    }
    
    func toggleSelectedWord(_ word: String) {
        if selectedWords.contains(word) {
            selectedWords.remove(word)
        }
        else {
            selectedWords.insert(word)
        }
    }
    func togglePrefix(_ letter: String) {
        prefix = prefix == letter ? nil : letter
    }
    
    func newWord() {
        wordsToAdd.append(WordToAdd())
    }
    
    func saveNewWord(_ word: WordToAdd) {
        
        let content = word.wrappedContent
        if words.contains(content) {
            showAlert(title: "Error saving \(content.capitalized)", message:"\(content.capitalized) is already in the database")
            word.content = ""
        } else {
            moc.performAndWait { [self] in
                let newWord = Word(context: moc)

                newWord.content = content
                db.addToWords(newWord)
                
                do {
                    try moc.save()
                    
                    DispatchQueue.main.async {
                        // quite inefficient to prepend element
                        filteredWords.insert(content, at: 0)
                        words.insert(content, at: 0)
                        
                        if let index = wordsToAdd.firstIndex(of: word) {
                            // to remove the textfield after saving the word
                            wordsToAdd.remove(at: index)
                        }
                    }
                } catch {
                    showAlert(title: "Error saving \(content)", message: String(describing: error))
                }
            }
        }
    }
    
    func deleteWords() {
        
        moc.performAndWait { [self] in
            
            let request: NSFetchRequest<Word> = Word.fetchRequest()
            print("deleting selected words: \(selectedWords)")
            request.predicate = NSPredicate(format: "content IN %@ AND databases CONTAINS %@", selectedWords, db)
            
            do {
                let fetchedWords = try moc.fetch(request)
                
                for word in fetchedWords {
                    print("removing \(word.wrappedContent)")
                    db.removeFromWords(word)
                }
                try moc.save()
            
                print("done removing")
                DispatchQueue.main.async { [self] in
                    print("updating UI")
                    for word in selectedWords {
                        print("removing \(word)")
                        words.remove(at: filteredWords.firstIndex(of: word)!)
                        filteredWords.remove(at: filteredWords.firstIndex(of: word)!)
                        
                    }
                    selectedWords = Set<String>()
                }
            } catch {
                showAlert(title: "Error deleting words", message: String(describing: error))
            }
        }
    }
    

}

class WordToAdd: Identifiable, Equatable {
    static func == (lhs: WordToAdd, rhs: WordToAdd) -> Bool {
        return lhs.id == rhs.id && lhs.content == rhs.content
    }
    var wrappedContent: String {
        get { self.content.lowercased().trim() }
    }
    var content = ""
    var id = UUID()
}
