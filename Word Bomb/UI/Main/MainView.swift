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
                LogoView()
                Color.clear

                VStack(spacing: 50) {
                    Button("START GAME") {
                        print("START GAME")
                        withAnimation { viewModel.changeViewToShow(.gameTypeSelect) }
                    }
                        
                    Button("Local Multiplayer") {
                        print("Local Multiplayer")
                        withAnimation {
                            viewModel.changeViewToShow(.multipeer)
                        }
                    }
                    
                    Button("CREATE MODE") {
                        print("Create New Mode")
                        withAnimation { creatingMode = true }
                    }
                    .buttonStyle(MainButtonStyle())
                    .sheet(isPresented: $creatingMode, onDismiss: {}) { CustomModeForm() }
                    
                    Button("SETTINGS") {
                        print("Settings")
                        withAnimation { changingSettings = true }
                    }
                    .buttonStyle(MainButtonStyle())
                    .sheet(isPresented: $changingSettings) { SettingsMenu(isPresented: $changingSettings).environmentObject(viewModel) }
                        
                }
                .padding(.top, 125)
                .buttonStyle(MainButtonStyle())
                .ignoresSafeArea(.all)
                
            }
            .helpSheet()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
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
