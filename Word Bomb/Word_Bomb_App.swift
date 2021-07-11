//
//  Word_Bomb_App.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI
import MultipeerKit
import MultipeerConnectivity


@main
struct Word_BombApp: App {

    let game: WordBombGameViewModel
    let persistenceController: PersistenceController
    
    init() {
        // register "default defaults"
        UserDefaults.standard.register(defaults: [
            "test" : 2,
            "Display Name": MCPeerID.defaultDisplayName,
            "Time Limit" : 10.0,
            "Time Difficulty" : 0.95,
            "Time Constraint" : 5.0,
            "Num Players" : 2,
            "Player Names" : ["Player"]
            // ... other settings
        ])
        
        game = WordBombGameViewModel(Defaults.gameModes)
        persistenceController = PersistenceController.shared
        
    }


    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(game)
                .environmentObject(Multipeer.dataSource)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}

