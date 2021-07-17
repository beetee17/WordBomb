//
//  Defaults.swift
//  Word Bomb
//
//  Created by Brandon Thio on 17/7/21.
//

import Foundation
import SwiftUI

struct Defaults {
    static let CountryGame = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "NAME A COUNTRY", words: nil, queries: nil, gameType: GameType.Exact, id: 1)
    
    static let CountryGameReverse = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "COUNTRIES STARTING WITH...", words: nil, queries: nil, gameType: GameType.Reverse, id: 2)
    
    static let WordGame = GameMode(modeName: "WORDS", dataFile: "words", queryFile: "syllables", instruction: "WORDS CONTAINING...", words: nil, queries: nil, gameType: GameType.Contains, id: 3)
    
    static let WordGameReverse = GameMode(modeName: "WORDS", dataFile: "words", queryFile: "syllables", instruction: "WORDS STARTING WITH...", words: nil, queries: nil, gameType: GameType.Reverse, id: 4)
    
    static let gameModes = [CountryGame, CountryGameReverse, WordGame, WordGameReverse]
    
    static let gameTypes = [("EXACT", GameType.Exact), ("CONTAINS", GameType.Contains), ("REVERSE", GameType.Reverse)]
    
    static let playerAvatarSize = UIScreen.main.bounds.width/3.5
    
    static let bombSize = UIScreen.main.bounds.width*0.4
    
    static let miniBombSize = UIScreen.main.bounds.width*0.2
    
    static let miniBombExplosionOffset = 10.0
    
    static let explosionDuration = 0.8
}
