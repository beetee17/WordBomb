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

enum InputStatus: String, Codable {
    case Correct
    case Wrong
    case Used
    
    func outputText(_ input: String) -> String {
        switch self {
        
        case .Correct:
            return "\(input) is Correct"
        case .Wrong:
            return "\(input) is Wrong"
        case .Used:
            return "Already used \(input)"
        }
    }
}

enum GameType: String, CaseIterable, Codable {
    case Classic = "Classic"
    case Exact = "Exact"
    case Reverse = "Reverse"
    
}

enum GameState: String, Codable {
    case initial, playerInput, playerTimedOut, gameOver, paused, playing
}


enum ViewToShow: String, Codable {
    case main, gameTypeSelect, modeSelect, game, pauseMenu, multipeer, peersView, GKMain, GKLogin
}
