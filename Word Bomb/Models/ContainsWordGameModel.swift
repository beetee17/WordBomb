//
//  ContainsWordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

struct ContainsWordGameModel: WordGameModel, Codable {
    var data: [String]
    var queries: [String]
    var usedWords = Set<Int>()
    
    mutating func process(_ input: String, _ query: String? = nil) -> (status: String, query: String?) {
        let searchResult = data.search(element: input)
        
        if usedWords.contains(searchResult) {
            print("\(input.uppercased()) ALREADY USED")
            return ("used", nil)
            
        }
        
        else if (searchResult != -1) && input.contains(query!) {
            print("\(input.uppercased()) IS CORRECT")
            usedWords.insert(searchResult)
            return ("correct", getRandQuery(input))
        }
                
        else {
            print("\(input.uppercased()) IS WRONG")
            return ("wrong", nil)

        }

    }
    
    mutating func resetUsedWords() {
        usedWords = Set<Int>()
    }
    
    mutating func getRandQuery(_ input: String? = nil) -> String {
        var query = queries.randomElement()!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        while query.count == 0 {
            // prevent blank query
            query = queries.randomElement()!
            print("getting random query \(query)")
        }
        print("GOT RANDOM QUERY \(query)")
        return query

    }

}

