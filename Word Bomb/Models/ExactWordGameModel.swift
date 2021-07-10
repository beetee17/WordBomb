//
//  ExactWordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

struct ExactWordGameModel: WordGameModel, Codable {
    var data: [String]
    var dataDict: [String : [String]]
    var usedWords = Set<Int>()
    
    mutating func process(_ input: String, _ query: String? = "") -> Answer {
        
        let searchResult = data.search(element: input)
        
        if usedWords.contains(searchResult) {
            print("\(input.uppercased()) ALREADY USED")
            return Answer.isAlreadyUsed
        }
        else if (searchResult != -1) {
            print("\(input.uppercased()) IS CORRECT")
            
            for variation in dataDict[input, default: []] {
                usedWords.insert(data.search(element: variation))
            }
            usedWords.insert(searchResult)
            return Answer.isCorrect
        }
                
        else {
            print("\(input.uppercased()) IS WRONG")
            return Answer.isWrong
        }
    }
    mutating func resetUsedWords() {
        usedWords = Set<Int>()
    }
    mutating func getRandQuery(_ input: String) -> String { return "" }

}
