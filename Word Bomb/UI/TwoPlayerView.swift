//
//  TwoPlayerView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 13/7/21.
//

import SwiftUI

struct TwoPlayerView: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        let player1 = viewModel.players.next(viewModel.players[0])
        let player2 = viewModel.players.next(player1)
        
        HStack {
            
        
            VStack(spacing: 5) {
                
                PlayerAvatar(player: player1)
                PlayerName(player: player1)
                PlayerLives(player: player1)
                
            }
            .scaleEffect(viewModel.currentPlayer == player1 ? 1 : 0.9)
            .blur(radius: viewModel.currentPlayer == player1  ? 0 : 2)
            
            Spacer()
            
            VStack(spacing: 5) {
                
                PlayerAvatar(player: player2)
                PlayerName(player: player2)
                PlayerLives(player: player2)
                
            }
            .scaleEffect(viewModel.currentPlayer == player2 ? 1 : 0.9)
            .blur(radius: viewModel.currentPlayer == player2 ? 0 : 2)
            
        }
        .padding(.horizontal, 40)
        .animation(.easeInOut)
        
        
        
    }
}

struct TwoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        TwoPlayerView().environmentObject(WordBombGameViewModel())
    }
}
