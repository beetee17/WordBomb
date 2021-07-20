//
//  WordGameModel.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation

protocol WordGameModel {
    var data:[String] { get }
    var usedWords: Set<Int> { get set }
    
    
    mutating func process(_ input: String, _ query: String?) -> (status: String, query: String?)
    mutating func reset()
    mutating func getRandQuery(_ input: String?) -> String
}


