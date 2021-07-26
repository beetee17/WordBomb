//
//  Enums.swift
//  Word Bomb
//
//  Created by Brandon Thio on 17/7/21.
//

import Foundation

struct GameMode: Identifiable, Codable {
    var modeName: String
    var dataFile: String?
    var queryFile: String?
    var instruction: String?
    
    // for custom modes
    var words: [String]?
    var queries: [String]?
    
    var gameType: GameType
    var id = UUID()
    
}


enum gameType: Int, Codable {
    case Classic = 0
    case Exact = 1
    case Reverse = 2
}

enum GameState: Int, Codable {
    case initial, playerInput, playerTimedOut, gameOver
}


enum ViewToShow: Int, Codable {
    case main, gameTypeSelect, modeSelect, game, pauseMenu, multipeer, peersView, GKMain, GKLogin, GKHost
}
