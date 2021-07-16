//
//  PlayerView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 6/7/21.
//

import SwiftUI


struct PlayerView: View {
    // Appears in game scene to display current player's name
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State var numPlaying: Int
    
    var body: some View {
        
        ZStack {
            switch numPlaying {
                
            case 3...Int.max:
                PlayerCarouselView()
                    .transition(.scale)
            case 2:
                TwoPlayerView()
                    .offset(x: 0, y: 50)
                    .transition(.scale)
            default:
                MainPlayer(player: viewModel.currentPlayer, animatePlayer: .constant(false))
                    .offset(x: 0, y: 50)
                    .transition(.scale)
                    
            }
        }
        .onAppear() {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                numPlaying = viewModel.players.numPlaying()
            }
        }

        .onChange(of: viewModel.gameState) { _ in
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                numPlaying = viewModel.players.numPlaying()
            }
        }
    }
}

struct PlayerName: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    var playerName: String
    
    var body: some View {
        switch .gameOver == viewModel.gameState && viewModel.currentPlayer.name == playerName {
        case true:
            
            Text("\(playerName) WINS!")
                .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                .lineLimit(1).minimumScaleFactor(0.5)
        case false:
            
            Text("\(playerName)")
                .font(.largeTitle)
                .lineLimit(1).minimumScaleFactor(0.5)
        }
    }
}

struct PlayerLives: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    var playerLives: Int
    
    var body: some View {
        
        HStack {
            
            // redraws the hearts when player livesLeft changes
            // smaller size depending on total number of lives to fit under avatar
            
            ForEach(0..<playerLives, id: \.self) { i in
                // draws remaining lives filled with red
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: viewModel.livesLeft > 4 ? CGFloat(68 / viewModel.livesLeft) : 20.0,
                           height: viewModel.livesLeft > 4 ? CGFloat(68 / viewModel.livesLeft) : 20.0,
                           alignment: .center)
                    .foregroundColor(.red)
                
            }
            
            ForEach(0..<viewModel.livesLeft - playerLives, id: \.self) { i in
                // draws lives lost (if any) unfilled
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: viewModel.livesLeft > 4 ? CGFloat(68 / viewModel.livesLeft) : 20.0,
                           height: viewModel.livesLeft > 4 ? CGFloat(68 / viewModel.livesLeft) : 20.0,
                           alignment: .center)
                    .foregroundColor(.red)
                
            }
        }
    }
}
struct PlayerAvatar: View {
    
    var playerName: String?
    
    var body: some View {
        let text = String(playerName?.first?.uppercased() ?? "")
        Image(systemName: "circle.fill")
            .resizable()
            .frame(width: Defaults.playerAvatarSize, height: Defaults.playerAvatarSize, alignment: .center)
            .foregroundColor(.gray)
            .overlay(Text(text)
                        .font(.system(size: 60,
                                      weight: .regular,
                                      design: .rounded))
                        .foregroundColor(.white))
            
    }
}
struct PlayerView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayerView(numPlaying: 3).environmentObject(WordBombGameViewModel())
    }
}
