//
//  MainView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 3/7/21.
//

import SwiftUI
import MultipeerKit
struct LocalMultiplayerView: View {
    
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State private var presentPeersSheet = false
    
    var body: some View {

        ZStack {
            
            MultiplayerDisplayName()
            
            VStack(spacing: 50) {
               
                
                Button("Host Game") {
                    print("Host Game")
                    withAnimation { presentPeersSheet = true }
                }
                .sheet(isPresented: $presentPeersSheet) { LocalPeersView() }
                
                Button("Reconnect") {
                    print("Reconnect")
                    withAnimation {
                        viewModel.disconnect()
                        Multipeer.reconnect()
                        
                    }
                }
                
                Button("Back") {
                    print("Back")
                    withAnimation { viewModel.changeViewToShow(.main) }
                }
                    
            }
            .buttonStyle(MainButtonStyle())
            
        }
        .helpSheet(title: "Local Multiplayer",
                   headers: ["HOST GAME", "RECONNECT"],
                   content: ["Invite nearby players to join your game!",
                             "Reconnect your device to the network if you encounter multiplayer related issues."])
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .ignoresSafeArea(.all)
//        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
        
    }
}
struct LocalMultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        LocalMultiplayerView()
    }
}