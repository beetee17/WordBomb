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
    
    mutating func process(_ input: String, _ query: String? = "") -> Answer {
        let searchResult = data.search(element: input)
        var answer = Answer.isCorrect
        
        if usedWords.contains(searchResult) {
            print("\(input.uppercased()) ALREADY USED")
            answer = .isAlreadyUsed
           
        }
        else if (searchResult != -1) && input.contains(query!) {
            print("\(input.uppercased()) IS CORRECT")
            usedWords.insert(searchResult)
 
        }
                
        else {
            print("\(input.uppercased()) IS WRONG")
            answer = .isWrong
        }
        
        
        return answer
    }
    
    mutating func resetUsedWords() {
        usedWords = Set<Int>()
    }
    
    mutating func getRandQuery(_ input: String) -> String{
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

