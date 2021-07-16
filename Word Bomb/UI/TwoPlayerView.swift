//
//  TwoPlayerView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 13/7/21.
//

import SwiftUI

struct TwoPlayerView: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @Namespace private var nameSpace
    
    private let bombSize = UIScreen.main.bounds.width*0.2
    private let bombOffset = 20.0
    
    var body: some View {
        
        let player1 = viewModel.players.next(viewModel.players[0])
        let player2 = viewModel.players.next(player1)
        
        HStack(spacing: 90) {
            ZStack {
                MainPlayer(player: player1, animatePlayer: .constant(false))
                    .scaleEffect(viewModel.currentPlayer == player1 ? 1 : 0.9)
                    .animation(.easeInOut)
                
                if viewModel.currentPlayer == player1 {

                    BombView()
                        .matchedGeometryEffect(id: "bomb", in: nameSpace)
                        .animation(.easeInOut)
                        .frame(width: bombSize, height: bombSize)
                        .offset(x: bombOffset, y: 0)
                        
                }
                
                else {
                    BombExplosion()
                        .animation(nil)
                        .frame(width: bombSize*1.5, height: bombSize*1.5)
                        .offset(x: bombOffset, y: 0)
                }
            }
            
            ZStack {
                MainPlayer(player: player2, animatePlayer: .constant(false))
                    .scaleEffect(viewModel.currentPlayer == player2 ? 1 : 0.9)
                    .animation(.easeInOut)

                if viewModel.currentPlayer == player2 {
                    BombView()
                        .matchedGeometryEffect(id: "bomb", in: nameSpace)
                        .animation(.easeInOut)
                        .frame(width: bombSize, height: bombSize)
                        .offset(x: -bombOffset, y: 0)                        

                }
                
                else {
                    BombExplosion()
                        .animation(nil)
                        .frame(width: bombSize*1.5, height: bombSize*1.5)
                        .offset(x: -bombOffset, y: 0)
                }
            }
            
        }
    }
}

struct TwoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        TwoPlayerView().environmentObject(WordBombGameViewModel())
    }
}
