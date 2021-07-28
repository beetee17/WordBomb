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
            Color.clear
            //
            VStack(spacing:50) {
                
                MultiplayerDisplayName()
                
                Game.mainButton(label: "HOST GAME", systemImageName: "person.crop.circle.badge.plus") {
                    print("Host Game")
                    withAnimation { presentPeersSheet = true }
                    
                }
                .sheet(isPresented: $presentPeersSheet) { LocalPeersView() }
                
                Game.mainButton(label: "DISCONNECT", systemImageName: "wifi.slash") {
                    print("Manual Disconnect")
                    withAnimation {
                        viewModel.disconnect()
                        
                        
                    }
                }
                Game.mainButton(label: "RECONNECT", systemImageName: "wifi.exclamationmark") {
                    print("Reconnect")
                    withAnimation {
                        viewModel.disconnect()
                        Multipeer.reconnect()
                    }
                }
                
                Game.backButton {
                    withAnimation { viewModel.changeViewToShow(.main) }
                }
            }
            
        }
        .helpSheet()
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
