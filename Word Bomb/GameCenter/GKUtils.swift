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
    
    static var isOffline: Bool { !isOnline }
    static var isOnline: Bool { viewModel.showMatch }
    static var isHost: Bool { hostPlayerName == nil && isOnline }
    static var isNonHost: Bool { hostPlayerName != nil && isOnline  }
    
    static func getGKHostPlayer() -> [GKPlayer] {
        guard let gkMatch = viewModel.gkMatch else { return [] }
        for gkPlayer in gkMatch.players {
            if gkPlayer.displayName == GameCenter.hostPlayerName {
                return [gkPlayer]
            }
        }
        return []
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
