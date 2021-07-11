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
            "Display Name": MCPeerID.defaultDisplayName,
            "Time Limit" : 5.0,
            "Time Difficulty" : 0.5,
            "Time Constraint" : 0,
            "Num Players" : 4,
            "Player Names" : ["Player"],
            "Player Lives" : 3
            // ... other settings
        ])
        
        game = WordBombGameViewModel()
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

