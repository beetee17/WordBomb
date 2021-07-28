//
//  ReverseWordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 9/7/21.
//

import Foundation

struct ReverseWordGameModel: WordGameModel {
    
    var words: [String]
    var dataDict: [String : [String]]
    var usedWords = Set<String>()
    
    mutating func process(_ input: String, _ query: String? = nil) -> (status: InputStatus, query: String?) {
  
        if usedWords.contains(input) {
            print("\(input.uppercased()) ALREADY USED")
            return (.Used, nil)
           
        }
        let searchResult = words.search(element: input)
        if searchResult != -1 && input.first == query!.last {
            print("\(input.uppercased()) IS CORRECT")
            
            usedWords.insert(input)
            
            for variation in dataDict[input, default: []] {
                usedWords.insert(variation)
            }
            
            return (.Correct, getRandQuery(input))
 
        }
                
        else {
            print("\(input.uppercased()) IS WRONG")
            return (.Wrong, nil)
          
        }
    }
    
    mutating func reset() {
        usedWords = Set<String>()
    }
    
    mutating func getRandQuery(_ input: String? = nil) -> String {
        if let input = input {
            return String(input.last!)
            
        }
        else {
            return String(words.randomElement()!.trim().last!)
        }
    }

}

