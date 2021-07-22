//
//  MainView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 3/7/21.
//

import SwiftUI
import GameKit
import GameKitUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State var creatingMode = false
    @State var changingSettings = false
    
    
    var body: some View {
        
        ZStack {
            
            Color.clear
            
            VStack(spacing:0) {
                
                LogoView()
                
                VStack(spacing: 35) {
                    Button(action: { withAnimation { viewModel.changeViewToShow(.gameTypeSelect) } }) {
                        HStack {
                            Image(systemName: "gamecontroller")
                            Text("START GAME")
                        }
                        
                    }
                    .buttonStyle(MainButtonStyle())
                    
                    
                    Button(action: { withAnimation { viewModel.changeViewToShow(.multipeer) } }) {
                        HStack {
                            Image(systemName: "wifi")
                            Text("MULTIPLAYER")
                            
                        }
                        
                    }
                    .buttonStyle(MainButtonStyle())
                    
                    Button(action:  { withAnimation { viewModel.changeViewToShow(.gameCenterInvite)
                    } })
                    {
                        HStack {
                            Image(systemName: "network")
                            Text("GAME CENTER")
                            
                        }
                    }
                    .buttonStyle(MainButtonStyle())
                    
                    
                    Button(action: { withAnimation { creatingMode = true } }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("CREATE MODE")
                        }
                    }
                    .buttonStyle(MainButtonStyle())
                    .sheet(isPresented: $creatingMode, onDismiss: {}) { CustomModeForm() }
                    
                    Button(action: { withAnimation { changingSettings = true } }) {
                        HStack {
                            Image(systemName: "gearshape")
                            Text("SETTINGS")
                        }
                        
                    }
                    .buttonStyle(MainButtonStyle())
                    .sheet(isPresented: $changingSettings) { SettingsMenu(isPresented: $changingSettings).environmentObject(viewModel) }
                    
                    
                }
                
            }
            .padding(.bottom, 20)
            
        }
        .helpSheet(title: "Welcome to Word Bomb",
                   headers: ["About", "HOW TO PLAY", "START GAME", "MULTIPLAYER", "CREATE MODE", "SETTINGS"],
                   content: ["Word Bomb is a multiplayer word game that allows you to test your quick-thinking and general knowledge of vocabulary or other custom categories such as countries.\n\nThere are 3 game types currently implemented: Classic, Exact and Reverse.",
                             "In all cases, players are tasked to form a word according to the game mode's instruction before their time runs out, which loses them a life. The last player standing is declared the winner of the game!\n\nIn a Classic game, players are given a randomly generated syllable, and your task is to come up with a valid word that contains the syllable.\n\nIn an Exact game, you must come up with an answer that is found in the mode's database. For example, a database of countries would mean players are only allowed to name countries. You can create your own custom database to play with friends!\n\nA Reverse game is similar to the Exact game, with the added constraint that the answer must start with the ending letter of the previous player's answer.",
                             "Press it to start a game!",
                             "This is where you are able to host a local multiplayer game with nearby players, and change your display name for online play.",
                             "This is where you can create your own custom modes to play with friends.",
                             "Customise various settings of the game mechanics here."])
        
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .leading), removal: AnyTransition.move(edge: .trailing)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
        
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(WordBombGameViewModel())
    }
}
