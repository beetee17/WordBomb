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
    var prevWord: String?
    var usedWords = Set<Int>()
    
    mutating func process(_ input: String, _ query: String? = "") -> Answer {
        let searchResult = data.search(element: input)
        var answer = Answer.isCorrect
        
        if usedWords.contains(searchResult) {
            print("\(input.uppercased()) ALREADY USED")
            answer = .isAlreadyUsed
           
        }
        else if (searchResult != -1) && input.first == prevWord!.last {
            print("\(input.uppercased()) IS CORRECT")
            for variation in dataDict[input, default: []] {
                usedWords.insert(data.search(element: variation))
            }
            usedWords.insert(searchResult)
            return Answer.isCorrect
 
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
        if prevWord == nil {
            prevWord = data.randomElement()!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        else {
            prevWord = input
            
        }
        return String(prevWord!.last!)
    }

}

