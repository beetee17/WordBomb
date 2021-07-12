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
    
    
    var body: some View {
        
        PlayerCarouselView()

        }
    
}

struct PlayerName: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        switch .gameOver == viewModel.gameState {
        case true:
         
            Text("\(viewModel.currentPlayer.name) WINS!")
                .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
        case false:
      
            Text("\(viewModel.currentPlayer.name)")
                .font(.largeTitle)
        }
    }
}

struct PlayerLives: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    var player: Player
    let playerLives = Float(UserDefaults.standard.integer(forKey: "Player Lives"))
    
    var body: some View {
 
        HStack {
            
            switch playerLives > 4 {
            case true:
                let heartSize = CGFloat(68.0 / playerLives)
                // redraws the hearts when player livesLeft changes
                ForEach(0..<player.livesLeft, id: \.self) { i in
                
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: heartSize, height: heartSize, alignment: .center)
                        .foregroundColor(.red)
                        
                }
                    
                ForEach(0..<UserDefaults.standard.integer(forKey: "Player Lives") - player.livesLeft, id: \.self) { i in
                
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: heartSize, height: heartSize, alignment: .center)
                        .foregroundColor(.red)
          
                }
                
            case false:
                let heartSize = 20.0
                // redraws the hearts when player livesLeft changes
                ForEach(0..<player.livesLeft, id: \.self) { i in
                
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: heartSize, height: heartSize, alignment: .center)
                        .foregroundColor(.red)
                        
                }
                    
                ForEach(0..<viewModel.livesLeft - player.livesLeft, id: \.self) { i in
                
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: heartSize, height: heartSize, alignment: .center)
                        .foregroundColor(.red)
          
                }
            }
            
        }
    }
    private func getHearts() {
        
    }
}
struct PlayerAvatar: View {
    var player: Player
    
    var body: some View {
        
        Image(systemName: "person.crop.circle")
            .resizable()
            .frame(width: 125, height: 125, alignment: .center)
    }
}
struct PlayerView_Previews: PreviewProvider {
  
    static var previews: some View {
        PlayerView().environmentObject(WordBombGameViewModel())
    }
}
