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
import CoreData


@main
struct Word_BombApp: App {
    
    @ObservedObject var gkViewModel = GameCenter.viewModel
    
    init() {
        // register "default defaults"
        UserDefaults.standard.register(defaults: [
            "First Launch" : true,
            "Initialised Database" : false,
            "Display Name": MCPeerID.defaultDisplayName.trim(),
            "Time Limit" : 10.0,
            "Time Multiplier" : 0.95,
            "Time Constraint" : 5.0,
            "Player Names" : ["A", "B", "C"],
            "Num Players" : 2,
            "Player Lives" : 3
            
            // ... other settings
        ])
        privateContext.automaticallyMergesChangesFromParent = true
        
    }
    var persistenceController = PersistenceController.shared

    let privateContext = PersistenceController.shared.container.newBackgroundContext()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                if self.gkViewModel.showAuthentication {
                    GKAuthenticationView { (error) in
                        self.gkViewModel.showAuthentication = false
                        self.gkViewModel.showAlert(title: "Authentication Failed", message: String(describing: error)) // change to something more user friendly on release?
                    } authenticated: { (player) in
                        self.gkViewModel.showAuthentication = false
                    }
                } else if self.gkViewModel.showInvite {
                    GKInviteView(
                        invite: self.gkViewModel.invite.gkInvite!
                    ) {
                    } failed: { (error) in
                        self.gkViewModel.showInvite = false
                        self.gkViewModel.showAlert(title: "Invitation Failed", message: String(describing: error)) // change to something more user friendly on release?
                        
                    } started: { (gkMatch) in
                        self.gkViewModel.gkMatch = gkMatch
                        
                    }
                } else if self.gkViewModel.showMatch, let gkMatch = self.gkViewModel.gkMatch {
                   
                    ZStack {
                        
                        Color("Background").ignoresSafeArea(.all)
                        GamePlayView(gkMatch: gkMatch) 
                            .environmentObject(self.gkViewModel)
                            .environmentObject(Game.viewModel)
                        
                    }
                    .onAppear {
                        Game.viewModel.disconnect()
                        Multipeer.transceiver.resume() // disconnect from local multiplayer
                        if Game.viewModel.viewToShow == .game || Game.viewModel.viewToShow == .pauseMenu {
                            Game.viewModel.changeViewToShow(.main)
                        }
                        
                        if GameCenter.isHost {
                            Game.viewModel.setOnlinePlayers(gkMatch.players)
                            Game.viewModel.startGame(mode: Game.WordGame)
                        }
                        Game.viewModel.forceHideKeyboard = false
                        
                    }
                }
                
                else {
                    ContentView()
                        .environmentObject(Game.viewModel)
                        .environmentObject(GameCenter.viewModel)
                        .environmentObject(GameCenter.loginViewModel)
                        .environmentObject(Multipeer.dataSource)
                        
                        .onAppear {
                            GKMatchManager.shared.cancel()
                            GameCenter.hostPlayerName = nil
                        }

                }
                
            }
            .banner(isPresented: $gkViewModel.showAlert,
                    title: gkViewModel.alertTitle, message: gkViewModel.alertMessage)
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "Initialised Database") {
                    initDatabases()
                }
            }
//            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environment(\.managedObjectContext, privateContext)
            
        }
        
    }
    
    func initDatabases() {
        privateContext.perform {
            let wordDB = Database(context: privateContext)
            wordDB.name = "words"

            let countryDB = Database(context: privateContext)
            countryDB.name = "country"
            
            try! privateContext.save()
            print("Initialised Databases")
            
            populateDatabases()
            UserDefaults.standard.setValue(true, forKey: "Initialised Database")
        }
        
    }
    
    func populateDatabases() {
        var count = 0
        let request: NSFetchRequest<Database> = Database.fetchRequest()
        
        request.predicate = NSPredicate(format: "TRUEPREDICATE")
        let databases = try! privateContext.fetch(request)
        print(databases)
        
        var database = databases.first(where: {$0.wrappedName == "words"})!
        for word in Game.dictionary {
            count += 1
            
            let newWord = Word(context: privateContext)
            newWord.content = word
            newWord.addToDatabases(database)
            
            if count % 100000 == 0 {
                print(count, newWord.databases!)
                try! privateContext.save()
            }
        }
        
        try! privateContext.save()
        print("Initialised Dictionary")
        
        count = 0
        database = databases.first(where: {$0.wrappedName == "country"})!
        
        for word in Game.countries {
            count += 1
            
            let newWord = Word(context: privateContext)
            newWord.content = word
            newWord.addToDatabases(database)
            
            if count % 100 == 0 {
                print(count, newWord.databases!)
                try! privateContext.save()
            }
        }
        
        try! privateContext.save()
        print("Initialised Countries")
    }
    
}

