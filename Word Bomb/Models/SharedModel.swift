//
//  WordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation

struct WordBombGame: Codable {
    
    // This model is the mainModel, it implements everything that is independent of the game mode. e.g. it should not implement the processInput function as that differs depending on game mode
    
    var players: [Player]
    var currentPlayer: Player
    
    var timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
    var timeLeft: Float?
    
    var mode: GameMode?
    
    var output = ""
    var query: String?
    var instruction: String?
    
    init() {
        players = []

        let playerNames: [String] = UserDefaults.standard.stringArray(forKey: "Player Names")!

        for i in 0..<UserDefaults.standard.integer(forKey: "Num Players") {
            players.append(Player(name: playerNames[i % playerNames.count], ID: i))
        }
        print(players)

        currentPlayer = players[0]
    }
    
    mutating func setPlayers(_ players: [Player]) {
        self.players = players
        currentPlayer = players[0]
    }
    
    mutating func process(_ input: String, _ answer: Answer) {
        
        // reset the time for other player iff answer from prev player was correct
        switch answer {
            case .isCorrect:
                output = "\(input) IS CORRECT"
                nextPlayer()
                resetTimer()
            case .isWrong:
                output = "\(input) IS WRONG"
            case .isAlreadyUsed:
                output = "ALREADY USED \(input)"
        }
    }
    
    
    mutating func resetTimer() {
        timeLimit = max(UserDefaults.standard.float(forKey:"Time Constraint"), timeLimit * UserDefaults.standard.float(forKey: "Time Difficulty"))
        timeLeft = timeLimit

    }
    
    mutating func clearOutput() { output =  "" }
    
    mutating func nextPlayer() {
        let nextPlayerID = (currentPlayer.ID + 1) % players.count
        currentPlayer = players[nextPlayerID]
        
        print(currentPlayer.name)
    }
        
    
    mutating func restartGame() {
        print(UserDefaults.standard.float(forKey: "Time Limit"))
        timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
        timeLeft = timeLimit
        
        currentPlayer = players[0]
    }
    

    mutating func clearUI() {
        output = ""
        query = ""
        instruction = ""
    }
}






