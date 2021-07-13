
//
//  PlayerCarouselView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 12/7/21.
//

import SwiftUI

struct PlayerCarouselView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State var animatePlayers = false
    
    var body: some View {
        let currentPlayer = viewModel.currentPlayer
        let prevPlayer = viewModel.players.prev(currentPlayer)
        let nextPlayer = viewModel.players.next(currentPlayer)
        let playerSize = 125.0
        let spacing = 8.0
        let screenWidth = UIScreen.main.bounds.width
//        ZStack {
//            VStack {
//                Spacer()
//
//            Button("ANIMATE") {
//                animatePlayers.toggle()
//            }
//
//            }
//
        HStack(spacing: spacing) {
            Spacer()
            LeftPlayer(player: animatePlayers ? currentPlayer : nextPlayer, animatePlayer: $animatePlayers)
                .scaleEffect(animatePlayers ? 1 : 0.9)
                .blur(radius: animatePlayers ? 0 : 1)
                .offset(x: animatePlayers ? screenWidth/2 - playerSize/2 - 11 : 0, y: 0)
            
            MainPlayer(player: animatePlayers ? prevPlayer : currentPlayer, animatePlayer: $animatePlayers)
                .scaleEffect(animatePlayers ? 0.9 : 1)
                .blur(radius: animatePlayers ? 1 : 0)
                .offset(x: animatePlayers ? screenWidth/2 - playerSize/2 - 11: 0, y:  0)
            RightPlayer(player: prevPlayer)
                .scaleEffect(0.9)
                .blur(radius: 1)
                .offset(x: animatePlayers ? -screenWidth + playerSize + 23: 0, y: 0)
            Spacer()
//        }
            
        }
        .animation(animatePlayers ? .easeInOut(duration: 0.3) : nil)
        
        .onChange(of: viewModel.currentPlayer, perform: { _ in
            
            withAnimation { animatePlayers.toggle() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32, execute: { animatePlayers = false })
            
        })
        
    }
}

struct LeftPlayer: View {
    var player: Player
    @Binding var animatePlayer: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            PlayerAvatar(player: player)
            if animatePlayer {
                PlayerName(player: player)
            }
            PlayerLives(player: player)

        }
    }
}


struct RightPlayer: View {
    var player: Player
    
    var body: some View {
        
        VStack(spacing: 5) {

            PlayerAvatar(player: player)
            PlayerLives(player: player)

        }
    }
}

struct MainPlayer:  View {
    var player: Player
    @Binding var animatePlayer: Bool
    var body: some View {
        
        VStack(spacing: 5) {

            PlayerAvatar(player: player)
            if !animatePlayer {
                PlayerName(player: player)
                    
            }
            PlayerLives(player: player)

        }
    }
}
struct PlayerCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerCarouselView().environmentObject(WordBombGameViewModel())
    }
}
