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
    // viewModel should start with no associated gameModel
    // no data to be loaded from file yet (until mode select)
    // however an array of [WordGame] should be loaded (for display of modes)
    // implement GameData struct, it includes String vars for words txt filename, query txt filename, user instruction (if any)
    
    let persistenceController = PersistenceController.shared
    let game = WordBombGameViewModel(Defaults.gameModes)
    
//    let mpcDataSource = MultipeerDataSource(transceiver: Multipeer.transceiver)
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(game)
                .environmentObject(Multipeer.dataSource)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}

