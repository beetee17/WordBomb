//
//  WordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation
import MultipeerKit

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
    
    var selectedPeers: [Peer] { Multipeer.selectedPeers }
    
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

    mutating func updateTimeLimit() {
        if currentPlayer == players.first! {
            timeLimit = max(UserDefaults.standard.float(forKey:"Time Constraint"), timeLimit * UserDefaults.standard.float(forKey: "Time Multiplier"))
            print("time multiplied")
        }
        timeLeft = timeLimit
    }
    mutating func process(_ input: String, _ response: (status: String, newQuery: String?)) {
        
        // reset the time for other player iff answer from prev player was correct
        if Multipeer.isHost {
            Multipeer.transceiver.send(["input" : input, "status" : response.status], to: selectedPeers)
        }
        else if GameCenter.isHost {
            GameCenter.sendDictionary(["input" : input, "status" : response.status], toHost: false)
        }

        switch response.status {
        case "correct":
            output = "\(input) IS CORRECT"

            if let newQuery = response.newQuery {
                self.query = newQuery
                
                if Multipeer.isHost {
                    Multipeer.transceiver.send(["query" : newQuery], to: selectedPeers)
                }
                else if GameCenter.isHost {
                    GameCenter.sendDictionary(["query" : newQuery], toHost: false)
                }
            }
            
            currentPlayer = playerQueue.nextPlayer(currentPlayer)
            
            if Multipeer.isOffline && GameCenter.isOffline {
                // only if host or offline should update time limit
                updateTimeLimit()
            }
            else if Multipeer.isHost  {
                updateTimeLimit()
                Multipeer.transceiver.send(["New Time Limit" : timeLimit], to: selectedPeers)
            }
            else if GameCenter.isHost {
                updateTimeLimit()
                GameCenter.sendDictionary(["New Time Limit" : String(timeLimit)], toHost: false)
            }
            
            
            
            
        case "wrong":
            output = "\(input) IS WRONG"
        case "used":
            output = "ALREADY USED \(input)"
        default: break
        }
    }
    
    

    
    mutating func clearOutput() { output =  "" }
    

    
    mutating func currentPlayerRanOutOfTime() {
        
        if Multipeer.isHost {
            Multipeer.transceiver.send("Current Player Timed Out", to: selectedPeers)
        }
        else if GameCenter.isHost {
            GameCenter.sendDictionary(["Player Timed Out" : "true"], toHost: false)
        }
        
        // mark player as no longer in the game
        currentPlayer.livesLeft -= 1
        
        for player in playerQueue {
            print("\(player.name): \(player.livesLeft) lives")
            
        }
        switch currentPlayer.livesLeft == 0 {
        case true:
            output = "\(currentPlayer.name) Lost!"
        case false:
            output = "\(currentPlayer.name) Ran Out of Time!"
        }
        
        currentPlayer = playerQueue.nextPlayer(currentPlayer)
        
        switch playerQueue.count < 2 {
        case true:
            // game over
            handleGameState(.gameOver)
        case false:
            // continue game
            updateTimeLimit()
        }

        
        
        animateExplosion = true
        
    }
    
    mutating func restartGame() {

        timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
        timeLeft = timeLimit
        
        players.reset()
        playerQueue = players
        currentPlayer = playerQueue[0]
        
    }
    mutating func updatePlayerLives(_ updatedPlayers: [Player]) {
        for i in self.playerQueue.indices {
            print("before updated \(playerQueue[i].name): \(playerQueue[i].livesLeft) lives")
            
            for player in updatedPlayers {
                if player.name == playerQueue[i].name && player.livesLeft != playerQueue[i].livesLeft{
                    
                    playerQueue[i].livesLeft = player.livesLeft
                    print("updated \(playerQueue[i].name): \(playerQueue[i].livesLeft) lives")
                }
            }
        }
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
            
            if Multipeer.isHost {
                Multipeer.transceiver.send(self, to: selectedPeers)
            }
            else if GameCenter.isHost {
                GameCenter.sendModel(self)
            }
            
        case .playerInput:
            if let input = data?["input"] as? String, let response = data?["response"] as? (String, String?) {
                
                process(input, response)
                print("shared model processing input")
                print("\(response)")
            }
            
        case .playerTimedOut:
            currentPlayerRanOutOfTime()
            
        case .gameOver:
            Game.stopTimer()

        }
    }
}






