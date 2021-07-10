//
//  MainView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 3/7/21.
//

import SwiftUI
import MultipeerKit
struct LocalMultiplayerView: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State private var presentPeersSheet = false
    var body: some View {
        // Start it up!
        
        ZStack {
            Color.clear
            
            MultiplayerDisplayName()
            
            VStack(spacing: 50) {
               
                
                Button("Host Game") {
                    print("Host Game")
                    withAnimation { presentPeersSheet = true }
                }
                Button("Disconnect") {
                    print("Disconnect")
                    withAnimation {
                        Multipeer.transceiver.stop()
                        for peer in viewModel.selectedPeers {
                            viewModel.toggle(peer)
                        }
                    }
                }
                Button("Reconnect") {
                    print("Reconnect")
                    withAnimation { Multipeer.transceiver.resume() }
                }
                
                Button("Back") {
                    print("Back")
                    withAnimation { viewModel.changeViewToShow(.main) }
                }
                    
            }
            .buttonStyle(MainButtonStyle())
            
        }
        .ignoresSafeArea(.all)
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
        .sheet(isPresented: $presentPeersSheet) { LocalPeersView() }
    }
}
struct LocalMultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        LocalMultiplayerView()
    }
}
