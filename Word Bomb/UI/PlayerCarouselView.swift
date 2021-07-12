
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
        
        ZStack {
//            TopBarView()
//            VStack {
//                Button("ANIMATE") {
//                    animatePlayers.toggle()
//                }
//                if animatePlayers {
//                    Text("ANIMATE")
//                }
//            }
//            .padding(.top, 50)
        
        HStack {
            
            LeftPlayer(player: prevPlayer, animatePlayer: $animatePlayers)
                .scaleEffect(animatePlayers ? 1 : 0.9)
                .blur(radius: animatePlayers ? 0 : 2)
                .offset(x: animatePlayers ? 133 : 0, y: animatePlayers ? 37 : 0)
            
            MainPlayer(player: currentPlayer, animatePlayer: $animatePlayers)
                .scaleEffect(animatePlayers ? 0.9 : 1)
                .blur(radius: animatePlayers ? 2 : 0)
                .offset(x: animatePlayers ? 133 : 0, y: animatePlayers ? -34 : 0)
            
            RightPlayer(player: nextPlayer)
                .scaleEffect(0.9)
                .blur(radius: 2)
                .offset(x: animatePlayers ?  -266 : 0, y: 0)
            
        }
        }
        .animation(animatePlayers ? .easeInOut : nil)
        
        .onChange(of: viewModel.currentPlayer, perform: { _ in
            
            animatePlayers = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { animatePlayers = false })
            
        })
        
    }
}

struct LeftPlayer: View {
    var player: Player
    @Binding var animatePlayer: Bool
    
    var body: some View {
        
        VStack(spacing: 5) {
            Spacer()
            
            PlayerAvatar(player: player)
            if animatePlayer {
                PlayerName()
            }
            PlayerLives(player: player)
            
            Spacer()
        }
//        .padding(.bottom, 525)
    }
}


struct RightPlayer: View {
    var player: Player
    
    var body: some View {
        
        VStack(spacing: 5) {
            Spacer()
            
            PlayerAvatar(player: player)
            PlayerLives(player: player)
            
            Spacer()
        }
//        .padding(.bottom, 525)
    }
}

struct MainPlayer:  View {
    var player: Player
    @Binding var animatePlayer: Bool
    var body: some View {
        
        VStack(spacing: 5) {
            Spacer()
            
            PlayerAvatar(player: player)
            if !animatePlayer {
                PlayerName()
            }
            PlayerLives(player: player)
            
            Spacer()
        }
        .padding(.top, 75)
    }
}
struct PlayerCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerCarouselView().environmentObject(WordBombGameViewModel())
    }
}
