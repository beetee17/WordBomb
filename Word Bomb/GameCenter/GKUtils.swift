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
    static var hostPlayerName: String? = nil
    static var isHost: Bool {
        hostPlayerName == GKLocalPlayer.local.displayName
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
}
