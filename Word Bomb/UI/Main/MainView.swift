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
                    
                    Button(action:  { withAnimation { viewModel.changeViewToShow(.gameCenterInvite)
                    } })
                    {
                        HStack {
                            Image("GK Icon")
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(height: 20)

                            Text("GAME CENTER")
                            
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
                   headers: ["Getting Started", "How to Play", "Start Game", "Game Center", "Local Multiplayer", "Custom Modes", "Settings"],
                   content: ["Word Bomb is a multiplayer word game that allows you to test your quick-thinking and general knowledge of vocabulary or other custom categories such as countries.\n\nThere are 3 game types currently implemented: Classic, Exact and Reverse.",
                             "In all cases, players are tasked to form a word according to the game mode's instruction before their time runs out, which loses them a life. The last player standing is declared the winner of the game!\n\nIn a Classic game, players are given a randomly generated syllable, and your task is to come up with a valid word that contains the syllable.\n\nIn an Exact game, you must come up with an answer that is found in the mode's database. For example, a database of countries would mean players are only allowed to name countries. You can create your own custom database to play with friends!\n\nA Reverse game is similar to the Exact game, with the added constraint that the answer must start with the ending letter of the previous player's answer.",
                             "Press to start a game! If you are not in an ongoing multiplayer game, you may start an offline, pass-and-play style game with preset number of players and player names (you can change this in the settings menu). Useful if you do not have a good network connection!\n\nIf you are hosting other players via local multiplayer, start a game in the same way to play with them!",
                             "Clicking the Game Center button allows you to play an online game with others through Game Center here! Simply navigate to the Host Game screen and invite yur friends! Currently does not support custom modes.",
                             "You can also play a local multiplayer game with nearby players via the Local Multiplayer button.",
                             "The Create Mode button presents a sheet where you can create your own custom modes to play with friends.",
                             "Customise various settings of the game mechanics here. Relevant settings will also apply to online gameplay if you are the host!"])
        
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
