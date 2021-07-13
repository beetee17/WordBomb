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
            
        
            MainPlayer(player: player1, animatePlayer: .constant(false))
            .scaleEffect(viewModel.currentPlayer == player1 ? 1 : 0.9)
    
            Spacer()
            
            MainPlayer(player: player2, animatePlayer: .constant(false))
            .scaleEffect(viewModel.currentPlayer == player2 ? 1 : 0.9)
            
        }
        .padding(.horizontal, 40)
        .animation(.easeInOut)
        .transition(.opacity)
        
        
        
    }
}

struct TwoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        TwoPlayerView().environmentObject(WordBombGameViewModel())
    }
}
