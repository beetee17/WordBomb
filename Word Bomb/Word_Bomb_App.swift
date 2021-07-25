//
//  Word_Bomb_App.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI
import MultipeerKit
import MultipeerConnectivity
import GameKit
import GameKitUI

// initialise default modes
let CountryGame = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "NAME A COUNTRY", words: nil, queries: nil, gameType: Game.types[.Exact], id: 1)

let CountryGameReverse = GameMode(modeName:"COUNTRY", dataFile: "countries", queryFile: nil, instruction: "COUNTRIES STARTING WITH...", words: nil, queries: nil, gameType: Game.types[.Reverse], id: 2)

let WordGame = GameMode(modeName: "WORDS", dataFile: "words", queryFile: "syllables_2", instruction: "WORDS CONTAINING...", words: nil, queries: nil, gameType: Game.types[.Classic], id: 3)

let WordGameReverse = GameMode(modeName: "WORDS", dataFile: "words", instruction: "WORDS STARTING WITH...", words: nil, queries: nil, gameType: Game.types[.Reverse], id: 4)

@main
struct Word_BombApp: App {
    
    @ObservedObject var gkViewModel = GameCenter.viewModel
    
    init() {
        // register "default defaults"
        UserDefaults.standard.register(defaults: [
            "Display Name": MCPeerID.defaultDisplayName.trim(),
            "Time Limit" : 10.0,
            "Time Multiplier" : 0.95,
            "Time Constraint" : 5.0,
            "Player Names" : ["A", "B", "C"],
            "Num Players" : 2,
            "Player Lives" : 3
            
            // ... other settings
        ])
    }
    var persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                
                if self.gkViewModel.showAuthentication {
                    GKAuthenticationView { (error) in
                        self.gkViewModel.showAuthentication = false
                        self.gkViewModel.showAlert(title: "Authentication Failed", message: error.localizedDescription)
                    } authenticated: { (player) in
                        self.gkViewModel.showAuthentication = false
                    }
                } else if self.gkViewModel.showInvite {
                    GKInviteView(
                        invite: self.gkViewModel.invite.gkInvite!
                    ) {
                    } failed: { (error) in
                        self.gkViewModel.showInvite = false
                        self.gkViewModel.showAlert(title: "Invitation Failed", message: error.localizedDescription)
                        
                    } started: { (gkMatch) in
                        self.gkViewModel.gkMatch = gkMatch
                        
                    }
                } else if self.gkViewModel.showMatch, let gkMatch = self.gkViewModel.gkMatch {
                    
                    ZStack {
                        let hostText = "\(GameCenter.isHost ? GKLocalPlayer.local.displayName : GameCenter.hostPlayerName) IS HOSTING"
                        Color("Background").ignoresSafeArea(.all)
                        GamePlayView(gkMatch: gkMatch) // change such tht it does not load until player images are loaded
                            .environmentObject(self.gkViewModel)
                            .environmentObject(Game.viewModel)
                        
                        VStack() {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(hostText)
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .ignoresSafeArea(.all)
                            }
                        }
                    }
                    .onAppear {
                        if GameCenter.isHost {
                            Game.viewModel.setGKPlayers(gkMatch.players)
                            Game.viewModel.startGame(mode: WordGame)
                        }
                        Game.viewModel.forceHideKeyboard = false
                        
                    }
                }
                
                else {
                    ContentView()
                        .environmentObject(Game.viewModel)
                        .environmentObject(Multipeer.dataSource)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    
                    //                        .alert(isPresented: $gkViewModel.showAlert) {
                    //                            Alert(title: Text(self.gkViewModel.alertTitle),
                    //                                  message: Text(self.gkViewModel.alertMessage),
                    //                                  dismissButton: .default(Text("Ok")))
                    //                        }
                }
                
            }
            .banner(isPresented: $gkViewModel.showAlert,
                    title: gkViewModel.alertTitle, message: gkViewModel.alertMessage)
            
        }
        
    }
}

