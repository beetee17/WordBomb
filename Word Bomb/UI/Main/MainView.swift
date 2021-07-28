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
    @State var showMultiplayerOptions = false
    
    @Namespace var mainView
    
    var body: some View {
        
        ZStack {
            
            Color.clear
            
            VStack(spacing:30) {
                if viewModel.animateLogo {
                    LogoView()
                        .matchedGeometryEffect(id: "logo", in: mainView, isSource: false)
                }
                
                VStack(spacing: 30) {
                    
                    Game.mainButton(label: "START GAME", systemImageName: "gamecontroller") {
                        withAnimation { viewModel.changeViewToShow(.gameTypeSelect) }
                    }
                    
                    
                    Game.mainButton(label: "MULTIPLAYER", systemImageName: "person.3") {
                        withAnimation {
                            showMultiplayerOptions.toggle()
                        }
                    }
                    
                if showMultiplayerOptions {
                    
                    VStack(spacing:10) {
                        Game.mainButton(label: "GAME CENTER",
                                        image: AnyView(Image("GK Icon")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 20))) {
                            withAnimation {
                                
                                // bug where tapping the back button in game center screen sometimes selected the local network button?
                                if viewModel.viewToShow == .main {
                                    print("selected game center")
                                    showMultiplayerOptions = false
                                    viewModel.changeViewToShow(.GKMain)
                                }
                            }
                        }
                        Game.mainButton(label: "LOCAL NETWORK", systemImageName: "wifi") {
                            withAnimation {
                                if viewModel.viewToShow == .main {
                                    print("selected local network")
                                    showMultiplayerOptions = false
                                    viewModel.changeViewToShow(.multipeer)
                                }
                            }
                        }
                    }
                    
                }
                    Game.mainButton(label: "CREATE MODE", systemImageName: "plus.circle") {
                        withAnimation { creatingMode = true }
                    }
                    .sheet(isPresented: $creatingMode, onDismiss: {}) { CustomModeForm() }
                    
                    
                    Game.mainButton(label: "SETTINGS", systemImageName: "gearshape") {
                        withAnimation { changingSettings = true }
                    }
                    .sheet(isPresented: $changingSettings) { SettingsMenu(isPresented: $changingSettings).environmentObject(viewModel) }
                    
                }
                .opacity(viewModel.showPreLaunchAnimation ? 0.01 : 1)
            }
            .padding(.bottom, 20)
            
            
            if !viewModel.animateLogo && viewModel.showPreLaunchAnimation {
                LogoView()
                    
                    .matchedGeometryEffect(id: "logo", in: mainView, isSource: true)
                    .frame(width: Device.width, height: Device.height, alignment: .center)
            }
            
        }
        .helpSheet(title: "Welcome to Word Bomb",
                   headers: ["Game Objective", "Game Types", "Start Game", "Game Center", "Local Multiplayer", "Custom Modes", "Settings"],
                   content: ["Word Bomb is a multiplayer word game that allows you to test your quick-thinking and general knowledge of vocabulary or other custom categories such as countries.\n\nPlayers are tasked to form a word according to the game mode's instruction before their time runs out, which loses them a life. The last player standing is declared the winner of the game!",
                             "There are 3 game types currently implemented: Classic, Exact and Reverse.\n\nIn a Classic game, players are given a randomly generated syllable, and your task is to come up with a valid word that contains the syllable.\n\nIn an Exact game, you must come up with an answer that is found in the mode's database. For example, a database of countries would mean players are only allowed to name countries. You can create your own custom database to play with friends!\n\nA Reverse game is similar to the Exact game, with the added constraint that the answer must start with the ending letter of the previous player's answer.",
                             "Press to start a game! If you are not in an ongoing multiplayer game, you may start an offline, pass-and-play style game with a specified number of players and custom player names (you can change this in the settings menu). Useful if you do not have a good network connection.\n\nIf you are hosting other players via local multiplayer, start a game in the same way to play with them!",
                             "Clicking the Game Center button allows you to play a truly online game with others via Game Center! Simply navigate to the Host Game screen and invite your friends!\n\nCurrently does not support custom modes.",
                             "You can also play a local multiplayer game with nearby players via the Local Multiplayer button.",
                             "The Create Mode button presents a sheet where you can create your own custom modes to play with friends.",
                             "Customise various settings of the game mechanics here. Relevant settings will also apply to online gameplay if you are the host!"])
        .onAppear() {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 1)) {
                viewModel.animateLogo = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                
                withAnimation(.easeInOut) { viewModel.showPreLaunchAnimation = false }
            }
        }
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .leading), removal: AnyTransition.move(edge: .trailing)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
        
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            MainView().environmentObject(WordBombGameViewModel())
        }
    }
}
