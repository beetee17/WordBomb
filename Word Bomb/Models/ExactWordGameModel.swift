//
//  ExactWordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

struct ExactWordGameModel: WordGameModel {
    var words: [String]
    var dataDict: [String : [String]]
    var usedWords = Set<String>()
    
    mutating func process(_ input: String, _ query: String? = nil) -> (status: String, query: String?) {
        
        if usedWords.contains(input) {
            print("\(input.uppercased()) ALREADY USED")
            return ("used", nil)
        }
        
        let searchResult = words.search(element: input)
        
        if searchResult != -1 {
            print("\(input.uppercased()) IS CORRECT")
            
            usedWords.insert(input)
            for variation in dataDict[input, default: []] {
                usedWords.insert(variation)
            }
            
            return ("correct", nil)
            
        }
                
        else {
            print("\(input.uppercased()) IS WRONG")
            return ("wrong", nil)
        }
    }
    
    mutating func reset() {
        usedWords = Set<String>()
    }
    mutating func getRandQuery(_ input: String? = nil) -> String { return "" }

}
