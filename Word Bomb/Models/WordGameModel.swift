//
//  WordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

protocol WordGameModel: Codable {
    var data:[String] { get }
    var usedWords: Set<Int> { get set }
    
    
    mutating func process(_ input: String, _ query: String?) -> Answer
    mutating func resetUsedWords()
    mutating func getRandQuery(_ input: String) -> String
}


