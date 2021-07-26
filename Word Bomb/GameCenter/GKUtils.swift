//
//  Utils.swift
//  Word Bomb
//
//  Created by Brandon Thio on 23/7/21.
//

import Foundation
import GameKit
import GameKitUI

struct GameCenter {
    static var viewModel = GKMatchMakerAppModel()
    static var loginViewModel = AuthenticationViewModel()
    
    static var hostPlayerName: String? = nil
    static var isHost: Bool {
        hostPlayerName == nil && viewModel.gkMatch != nil
    }
    static var isNonHost: Bool { hostPlayerName != nil && viewModel.gkMatch != nil }
    static var isOffline: Bool {
        viewModel.gkMatch == nil
    }
    static var isOnline: Bool {
        !isOffline
    }
    static func getGKHostPlayer() -> [GKPlayer] {
        guard let gkMatch = viewModel.gkMatch else { return [] }
        for gkPlayer in gkMatch.players {
            if gkPlayer.displayName == GameCenter.hostPlayerName {
                return [gkPlayer]
            }
        }
        return []
    }
    
    static func sendDictionary(_ dictionary: [String : String], toHost: Bool) {
        if let data = encodeDict(dictionary) {
            send(data, toHost: toHost)
        }
    }
    static func sendModel(_ model: WordBombGame) {
        do {
            let data = try JSONEncoder().encode(model)
            send(data, toHost: false)
            
        } catch {
            print("Could not encode model")
            print(error.localizedDescription)
        }
    }
    static func sendPlayerLives(_ players: [Player]) {
        
        var playerData: [String] = []
        for player in players {
            let nameAndLives = "\(player.name):\(player.livesLeft)"
            playerData.append(nameAndLives)
        }
        let data = playerData.joined(separator: ",")
        sendDictionary(["Updated Player Lives" : data], toHost: false)
        
    }
    
    static func send(_ data: Data, toHost: Bool) {
        do {
            switch toHost {
            case true:
                let hostPlayer = GameCenter.getGKHostPlayer()
                try viewModel.gkMatch?.send(data, to: hostPlayer, dataMode: .reliable)
            case false:
                try viewModel.gkMatch?.sendData(toAllPlayers: data, with: .reliable)
            }
            print("SENT \(data), to host: \(toHost)")
        } catch {
            print("could not send GK data")
            print(error.localizedDescription)
        }
    }
}
