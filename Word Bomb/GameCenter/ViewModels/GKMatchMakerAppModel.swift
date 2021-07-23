///
/// MIT License
///
/// Copyright (c) 2020 Sascha Müllner
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Created by Sascha Müllner on 24.11.20.

import os.log
import Combine
import Foundation
import GameKit
import GameKitUI

class GKMatchMakerAppModel: NSObject, ObservableObject {

    @Published public var showAlert = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""

    @Published public var showAuthentication = false
    @Published public var showInvite = false
    @Published public var showMatch = false
    @Published public var invite: Invite = Invite.zero {
        didSet {
            self.showInvite = invite.gkInvite != nil
            GameCenter.hostPlayerName = invite.gkInvite?.sender.displayName
            self.showAuthentication = invite.needsToAuthenticate ?? false
        }
    }
    @Published public var gkMatch: GKMatch? {
        didSet {
            self.showInvite = false
            self.showMatch = true
            
        }
    }

    private var cancellableInvite: AnyCancellable?
    private var cancellableMatch: AnyCancellable?
    
    public override init() {
        super.init()
        self.subscribe()
    }

    deinit {
        self.unsubscribe()
    }
    
    func subscribe() {
        self.cancellableInvite = GKMatchManager
            .shared
            .invite
            .sink { (invite) in
                self.invite = invite
        }
        self.cancellableMatch = GKMatchManager
            .shared
            .match
            .sink { (match) in
                self.gkMatch = match.gkMatch
                self.gkMatch?.delegate = self
               
                
        }
    }

    func unsubscribe() {
        self.cancellableInvite?.cancel()
        self.cancellableMatch?.cancel()
    }

    public func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}

extension GKMatchMakerAppModel: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        do {
//            print(String(data: data, encoding: .utf8))
            let gameModel = try JSONDecoder().decode(WordBombGame.self, from: data)
            Game.viewModel.setGameModel(gameModel)
            Game.viewModel.startTimer()
            
        } catch {
            print("error getting model from host")
            print(String(describing: error))
            do {
                print(String(data: data, encoding: .utf8))
                let data = try JSONDecoder().decode([String : String].self, from: data)
                if let hostPlayerName = data["Host Name"] {
                    GameCenter.hostPlayerName = hostPlayerName
                    print("Got host name \(hostPlayerName)")
                }
                
                if let input = data["nonHostInput"] {
                    print("Host received input \(input)")
                    Game.viewModel.processPeerInput(input)
                }

                if let input = data["input"], let status = data["status"] {
                    print("Non host received response status  \(status) for input \(input)")
                    
                    let nilQuery: String? = nil
                    Game.viewModel.handleGameState(.playerInput,
                                               data: ["input" : input,
                                                      "response" : (status, nilQuery)])
                }
                
                if let query = data["query"] {
                    print("Non host received updated query \(query)")
                    Game.viewModel.query = query
                }
                if let playerTimedOut = data["Player Timed Out"] {
                    print("Non host notified of player time out \(playerTimedOut)")
                    Game.viewModel.handleGameState(.playerTimedOut)
                }
                
                if let timeLeft = data["Updated Time Left"] {
                    print("Non host notified of updated time left \(String(format: "%.1f", timeLeft))")
                    Game.viewModel.timeLeft = Float(timeLeft)!
                    
                }
                if let timeLimit = data["New Time Limit"] {
                    print("Non host notified of new time limit \(String(format: "%.1f", timeLimit))")
                    Game.viewModel.timeLimit = Float(timeLimit)!
                }
                
                
            } catch {
                print("error getting input from non-host")
                print(String(describing: error))
                
            }
            
        }
        
    }
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        print("player \(player) connection status changed to \(state)")
        print("players left \(match.players)")
        
        if GameCenter.isHost {
            // set new players
            switch match.players.count > 0 {
            case true:
                // simply reset players without disconnected player
                Game.viewModel.setGKPlayers(match.players)
            case false:
                //end the game if no players left
                match.disconnect()
                match.delegate = nil
                
                DispatchQueue.main.async {
                    Game.viewModel.resetGameModel()
                    self.gkMatch = nil
                    self.showMatch = false
                }
            }
        }
        
        if .disconnected == state && player.displayName == GameCenter.hostPlayerName {
                        // exit the game if host disconnect
            GameCenter.hostPlayerName = nil
            match.disconnect()
            match.delegate = nil
            DispatchQueue.main.async {
                Game.viewModel.resetGameModel()
                self.gkMatch = nil
                self.showMatch = false
            }
        }
    }
}


