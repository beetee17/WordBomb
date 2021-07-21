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
                
                
                Button(action: {
                    
                    print("Host Game")
                    withAnimation { presentPeersSheet = true }
                }) {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.plus")
                        Text("HOST GAME")
                    }
                }
                
                .buttonStyle(MainButtonStyle())
                .sheet(isPresented: $presentPeersSheet) { LocalPeersView() }
                
                Button(action:{
                    
                    print("Reconnect")
                    withAnimation {
                        viewModel.disconnect()
                        Multipeer.reconnect()
                        
                    } }) {
                        
                        HStack {
                            Image(systemName: "wifi.exclamationmark")
                            Text("RECONNECT")
                        }
                        
                    }
                    .buttonStyle(MainButtonStyle())
                
                Button(action: { withAnimation { viewModel.changeViewToShow(.main) } }) {
                    Image(systemName: "arrow.backward")
                        .font(Font.title.bold())
                        .foregroundColor(.white)
                    
                }
            }
            
        }
        .helpSheet(title: "Local Multiplayer",
                   headers: ["How To", "Display Name", "Host Game", "Reconnect"],
                   content: ["You may connect with players nearby by connecting to the same network with bluetooth enabled! One player should assume responsibility of the host by inviting players via the 'HOST GAME' button.\n\nOnce all players have been invited, the host can simply start a game (including custom modes he/she created) for all to play!",
                             "You may edit your multiplayer display name by tapping on the text field.",
                             "Invite nearby players to join your game!",
                             "Reconnect your device to the network if you encounter multiplayer related issues."])
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .ignoresSafeArea(.all)
        
    }
}
struct LocalMultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        LocalMultiplayerView()
    }
}
