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
    private let bombOffset: Float = 5.0
    
    var body: some View {
        
        let player1 = viewModel.players.next(viewModel.players[0])
        let player2 = viewModel.players.next(player1)
        
        ZStack {
            HStack(spacing: 90) {
                
                ZStack {
                    MainPlayer(player: player1, animatePlayer: .constant(false))
                        .scaleEffect(viewModel.currentPlayer == player1 ? 1 : 0.9)
                        .animation(.easeInOut)
                    
                    
                }
                
                ZStack {
                    MainPlayer(player: player2, animatePlayer: .constant(false))
                        .scaleEffect(viewModel.currentPlayer == player2 ? 1 : 0.9)
                        .animation(.easeInOut)
                    
                }
                
            }
            .frame(minWidth: UIScreen.main.bounds.width*0.85, maxWidth: UIScreen.main.bounds.width*0.85, minHeight: 0, alignment: .top)
            
            BombView()
            
                .frame(width: bombSize,
                       height: bombSize)
                .offset(x: viewModel.currentPlayer == player1 ? -UIScreen.main.bounds.width*0.425 + Defaults.playerAvatarSize*0.75 : UIScreen.main.bounds.width*0.425 - Defaults.playerAvatarSize*0.75,
                        y: 0)
                .animation(.easeInOut(duration: 0.3).delay(.playerTimedOut == viewModel.gameState ? 0.8 : 0))
                .overlay (
                    BombExplosion()
                        .frame(width: bombSize*1.5,
                               height: bombSize*1.5)
                        .offset(x: viewModel.currentPlayer == player2 ? -UIScreen.main.bounds.width*0.425 + Defaults.playerAvatarSize*0.75 + bombOffset : UIScreen.main.bounds.width*0.425 - Defaults.playerAvatarSize*0.75 + bombOffset,
                                y: bombOffset)
                )
            
            
            
            
        }
    }
}

struct TwoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        //        Test()
        TwoPlayerView().environmentObject(WordBombGameViewModel())
    }
}

//import SDWebImageSwiftUI
//struct Test: View {
//    @State var animate = false
//    var body: some View {
//        VStack {
//            AnimatedImage(name: "explosion-2-merge.gif", isAnimating: $animate)
////                .resizable()
//                .customLoopCount(1)
//                
////                .frame(width:200, height:200)
//            
//            Button("PLAY") {
//                animate.toggle()
//            }
//        }
//    }
//}

