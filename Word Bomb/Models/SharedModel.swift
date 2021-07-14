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
    var livesLeft = UserDefaults.standard.integer(forKey: "Player Lives")
    
    var timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
    var timeLeft = UserDefaults.standard.float(forKey: "Time Limit")

    var gameState: GameState = .initial
    
    var output = ""
    var query: String?
    var instruction: String?
    
    init() {
        players = []

        let playerNames: [String] = UserDefaults.standard.stringArray(forKey: "Player Names")!

        for i in 0..<UserDefaults.standard.integer(forKey: "Num Players") {
            
            if i >= playerNames.count {
                players.append(Player(name: "Player", id: i))
            }
            else {
            players.append(Player(name: playerNames[i], id: i))
            }
        }

        currentPlayer = players[0]
    }
    
    
    mutating func resetPlayers(_ players: [Player]? = nil) {
        if let players = players {
            self.players = players
            currentPlayer = players[0]
        }
        else {
            self.players = []

            let playerNames: [String] = UserDefaults.standard.stringArray(forKey: "Player Names")!

            for i in 0..<UserDefaults.standard.integer(forKey: "Num Players") {
                self.players.append(Player(name: playerNames[i % playerNames.count], id: i))
            }

            currentPlayer = self.players[0]
        }
    }
    
    mutating func process(_ input: String, _ response: (status: String, newQuery: String?)) {
        
        // reset the time for other player iff answer from prev player was correct
        switch response.status {
        case "correct":
            output = "\(input) IS CORRECT"
            query = response.newQuery
            currentPlayer = players.next(currentPlayer)
            timeLimit = max(UserDefaults.standard.float(forKey:"Time Constraint"), timeLimit * UserDefaults.standard.float(forKey: "Time Difficulty"))
            timeLeft = timeLimit
            
        case "wrong":
            output = "\(input) IS WRONG"
        case "used":
            output = "ALREADY USED \(input)"
        default: break
        }
    }
    
    

    
    mutating func clearOutput() { output =  "" }
    

    
    mutating func currentPlayerRanOutOfTime() {

        // mark player as no longer in the game
        currentPlayer.didRunOutOfTime()
        
        switch players.numPlaying() < 2 {
        case true:
            // game over
            gameState = .gameOver
        case false:
            // continue game
            timeLeft = timeLimit
        }
        
        switch currentPlayer.livesLeft == 0 {
        case true:
            output = "\(currentPlayer.name) Lost!"
        case false:
            output = "\(currentPlayer.name) Ran Out of Time!"
        }
        print("lives left: \(currentPlayer.livesLeft)")
        currentPlayer = players.next(currentPlayer)
    }
    
    mutating func restartGame() {

        timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
        timeLeft = timeLimit
        
        players.reset()
        currentPlayer = players[0]
        
    }
    

    mutating func clearUI() {
        output = ""
        query = ""
        instruction = ""
    }
    
    mutating func handleGameState(_ gameState: GameState, data: [String : Any]? = [:]) {
        self.gameState = gameState
        
        switch gameState {
            
        case .initial:
            clearUI()
            
            if let players = data?["players"] as? [Player] {
                resetPlayers(players)
                
            }
            restartGame()
            
            if let query = data?["query"] as? String {
                self.query = query
            }
            if let instruction = data?["instruction"] as? String {
                self.instruction = instruction
            }
            
        case .playerInput:
            if let input = data?["input"] as? String, let response = data?["response"] as? (String, String?) {
                process(input, response)
            }
            
        case .playerTimedOut:
            currentPlayerRanOutOfTime()
            
        case .gameOver:
            break

        }
    }
}






