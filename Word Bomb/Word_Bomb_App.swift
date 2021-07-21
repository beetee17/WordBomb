//
//  Word_Bomb_App.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI
import MultipeerKit
import MultipeerConnectivity

// initialise default modes
let CountryGame = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "NAME A COUNTRY", words: nil, queries: nil, gameType: Game.types[.Exact], id: 1)

let CountryGameReverse = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "COUNTRIES STARTING WITH...", words: nil, queries: nil, gameType: Game.types[.Reverse], id: 2)

let WordGame = GameMode(modeName: "WORDS", dataFile: "words", queryFile: "syllables_2", instruction: "WORDS CONTAINING...", words: nil, queries: nil, gameType: Game.types[.Classic], id: 3)

let WordGameReverse = GameMode(modeName: "WORDS", dataFile: "words", instruction: "WORDS STARTING WITH...", words: nil, queries: nil, gameType: Game.types[.Reverse], id: 4)

@main
struct Word_BombApp: App {

    let game: WordBombGameViewModel
    
    
    init() {
        // register "default defaults"
        UserDefaults.standard.register(defaults: [
            "Display Name": MCPeerID.defaultDisplayName.trim(),
            "Time Limit" : 10.0,
            "Time Multiplier" : 0.95,
            "Time Constraint" : 5.0,
            "Num Players" : 3,
            "Player Lives" : 3,
            "Player Names" : ["A", "B", "C"]
            
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

