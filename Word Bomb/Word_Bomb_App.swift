//
//  Word_Bomb_App.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI
import MultipeerKit
import MultipeerConnectivity

let gameTypes = [GameType(name: "Classic", type: gameType.Classic), GameType(name: "EXACT", type: gameType.Exact), GameType(name:"REVERSE", type:gameType.Reverse)]

@main
struct Word_BombApp: App {

    let game: WordBombGameViewModel
    
    
    init() {
        // register "default defaults"
        UserDefaults.standard.register(defaults: [
            "Display Name": MCPeerID.defaultDisplayName.trim(),
            "Time Limit" : 5.0,
            "Time Difficulty" : 0.5,
            "Time Constraint" : 0,
            "Num Players" : 4,
            "Player Names" : ["A", "B", "C"],
            "Player Lives" : 3
            // ... other settings
        ])
        
        game = WordBombGameViewModel()
        
        
        
    }

    var body: some Scene {
        
        WindowGroup {
            Prelaunch()
                .environmentObject(game)
                .environmentObject(Multipeer.dataSource)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}

