//
//  ReverseWordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 9/7/21.
//

import Foundation

struct ReverseWordGameModel: WordGameModel, Codable {
    
    var data: [String]
    var dataDict: [String : [String]]
    var usedWords = Set<Int>()
    
    mutating func process(_ input: String, _ query: String? = nil) -> (status: String, query: String?) {
        let searchResult = data.search(element: input)
        
        if usedWords.contains(searchResult) {
            print("\(input.uppercased()) ALREADY USED")
            return ("used", nil)
           
        }
        
        else if (searchResult != -1) && input.first == query!.last {
            print("\(input.uppercased()) IS CORRECT")
            for variation in dataDict[input, default: []] {
                usedWords.insert(data.search(element: variation))
            }
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
        if let input = input {
            return String(input.last!)
            
        }
        else {
            return data.randomElement()!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

}

