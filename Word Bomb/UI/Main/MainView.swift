//
//  MainView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 3/7/21.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State var creatingMode = false
    @State var changingSettings = false

    
    var body: some View {
        
            ZStack {
                VStack {
                    LogoView()
                    Spacer()
                }
                Color.clear

                VStack(spacing: 50) {
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
                .padding(.top, 125)
                .ignoresSafeArea(.all)
                
            }
            .helpSheet(title: "Welcome to Word Bomb",
                       headers: ["START GAME", "LOCAL MULTIPLAYER", "CREATE MODE", "SETTINGS"],
                       content: ["Press this to start a game!",
                                 "This is where you are able to host a multiplayer game with nearby players!",
                                 "This is where you can create your own custom modes to play with friends!",
                                 "This is where you can customise various settings of the game mechanics"])

            .transition(.asymmetric(insertion: AnyTransition.move(edge: .leading), removal: AnyTransition.move(edge: .trailing)))
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
            .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
            
    }
}


//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView().environmentObject(WordBombGameViewModel())
//    }
//}
