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
        
        VStack {
            Spacer()
            
            switch .gameOver == viewModel.gameState {
            case true:
             
                Text("\(viewModel.currentPlayer.name) WINS!")
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
            case false:
          
                Text("\(viewModel.currentPlayer.name)'s Turn!")
                    .font(.largeTitle)
            }
            
            HStack {
                // redraws the hearts when player livesLeft changes
                ForEach(0..<viewModel.currentPlayer.livesLeft, id: \.self) { i in
                
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
                    
                ForEach(0..<UserDefaults.standard.integer(forKey: "Player Lives") - viewModel.currentPlayer.livesLeft, id: \.self) { i in
                
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                        
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 500)
    }
}


struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
