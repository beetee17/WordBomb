//
//  TopBarView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 6/7/21.
//

import SwiftUI


struct TopBarView: View {
    // Appears in game screen for user to access pause menu, restart a game
    // and see current time left
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var gameOverButton: some View {
        Button("Restart") {
            print("Restart Game")
            viewModel.restartGame()
        }
    }
    
    var body: some View {

        
            HStack {
                Button("Pause") {
                    print("Pause Game")
                
                    withAnimation(.spring(response:0.1, dampingFraction:0.6)) { viewModel.changeViewToShow(.pauseMenu) }
                }
                
                Spacer()
 
                if viewModel.playerQueue.count > 2 {
                    ZStack {
                        BombView()
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(String(format: "%.1f", viewModel.timeLeft))
                                    .foregroundColor(.white)
                                    .offset(x: 5, y: 10))
                            
               
                        BombExplosion()
                            .offset(x: 10, y: 10)
                        // to center explosion on bomb
                    }
                }
                
                else {
                    Text(String(format: "%.1f", viewModel.timeLeft))
                        .font(.largeTitle)
                }
  
                Spacer()
  
                if .gameOver == viewModel.gameState { gameOverButton.opacity(1) }
                else { gameOverButton.opacity(0) }
            }
            .padding(.horizontal, 20)
            .padding(.top, viewModel.playerQueue.count > 2 ? 0 : 50)
        
    }
    
 
}




struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView().environmentObject(WordBombGameViewModel())
    }
}
