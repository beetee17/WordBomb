//
//  MultipeerStatusText.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI
import MultipeerKit

struct MPCText: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    
    var body: some View {
        VStack {
            
            let mpcStatusText = Text(viewModel.mpcStatus)
            
            let text = viewModel.mpcStatus.lowercased()
            switch text.contains("connected to") || text.contains("are host") {
            case true:
                mpcStatusText.foregroundColor(.green)
                
            case false:
                mpcStatusText.foregroundColor(.red)
                
            }
            
        
            Spacer()

        }
        .font(.caption)
        .padding(.top, 40)
        .ignoresSafeArea(.all)
        .environmentObject(mpcDataSource)
        .onChange(of: mpcDataSource.availablePeers,
                  perform: {
                    _ in
                    DispatchQueue.main.async {
                        handlePeersChanged(viewModel, mpcDataSource)
                    }
                  })
        .onChange(of: viewModel.selectedPeers, perform: { _ in
            if viewModel.selectedPeers.count > 0 {
                
                viewModel.mpcStatus = "You are host"
            }
            
            
        })
    
    }
}

func handlePeersChanged(_ viewModel: WordBombGameViewModel, _ mpcDataSource: MultipeerDataSource) {
    // non-host device lost connection to host
    if let hostPeer = viewModel.hostingPeer, !mpcDataSource.availablePeers.contains(hostPeer) {
        viewModel.mpcStatus = "Lost connection to host"
        viewModel.hostingPeer = nil
        viewModel.resetPlayers()
    }
    
    else if viewModel.selectedPeers.count > 0 {
        // host device lost connection to all participants
        if mpcDataSource.availablePeers.count == 0 {
            viewModel.mpcStatus = "Lost connection to all participants"
            for peer in viewModel.selectedPeers { viewModel.toggle(peer) }
            viewModel.resetPlayers()
        }
        
        else {
            // host may have lost connection to some/all players (still >1 player in the game) -> update players in the game
            viewModel.mpcStatus = "Lost connection to some participants"
            for peer in viewModel.selectedPeers {
                if !mpcDataSource.availablePeers.contains(peer) {
                    //remove the peer
                    
                    viewModel.toggle(peer)
                }
            }
            if viewModel.selectedPeers.count == 0 {
                viewModel.mpcStatus = "Lost connection to all participants"
                viewModel.resetPlayers()
                
            }
            
            // reset players in game
            else { viewModel.setPlayers() }
        }
    }
}



struct MultipeerStatusText_Previews: PreviewProvider {
    static var previews: some View {
        MPCText()
    }
}

