//
//  WordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation

struct WordBombGame: Codable {
    
    // This model is the mainModel, it implements everything that is independent of the game mode. e.g. it should not implement the processInput function as that differs depending on game mode
    
    var playerQueue: [Player]
    var players: [Player]
    
    var currentPlayer: Player
    var livesLeft = UserDefaults.standard.integer(forKey: "Player Lives")
    
    var timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
    var timeLeft = UserDefaults.standard.float(forKey: "Time Limit")

    var gameState: GameState = .initial
    
    var output = ""
    var query: String?
    var instruction: String?
    
    var animateExplosion: Bool = false
    
    
    
    
    init(_ players: [Player]? = nil) {
        if let players = players {
            self.playerQueue = players
            
        }
        else {
            self.playerQueue = []

            let playerNames: [String] = UserDefaults.standard.stringArray(forKey: "Player Names")!

            for i in 0..<UserDefaults.standard.integer(forKey: "Num Players") {
                
                if i >= playerNames.count {
                    self.playerQueue.enqueue(Player(name: "Player \(i+1)"))
                }
                else {
                    self.playerQueue.enqueue(Player(name: playerNames[i]))
                }
            }
        }

        self.currentPlayer = self.playerQueue[0]
        self.players = self.playerQueue
    }

    mutating func updateTime() {
        if currentPlayer == players.first! {
            timeLimit = max(UserDefaults.standard.float(forKey:"Time Constraint"), timeLimit * UserDefaults.standard.float(forKey: "Time Multiplier"))
            print("time multiplied")
        }
    }
    mutating func process(_ input: String, _ response: (status: String, newQuery: String?)) {
        
        // reset the time for other player iff answer from prev player was correct
        switch response.status {
        case "correct":
            output = "\(input) IS CORRECT"
            query = response.newQuery
            
            currentPlayer = playerQueue.nextPlayer(currentPlayer)
            
            updateTime()
            
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
        
        switch playerQueue.numPlaying() < 2 {
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
        currentPlayer = playerQueue.nextPlayer(currentPlayer)
        updateTime()
        
        animateExplosion = true
        

    }
    
    mutating func restartGame() {

        timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
        timeLeft = timeLimit
        
        players.reset()
        playerQueue = players
        currentPlayer = playerQueue[0]
        
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
                self = .init(players)
                
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






