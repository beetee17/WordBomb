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

        VStack{
            HStack {
                Button("Pause") {
                    print("Pause Game")
                    hideKeyboard()
                    withAnimation(.spring(response:0.1, dampingFraction:0.6)) { viewModel.changeViewToShow(.pauseMenu) }
                }
                
                Spacer()
                
                TimerView(viewModel: viewModel)
                
                Spacer()
  
                if .gameOver == viewModel.viewToShow { gameOverButton.opacity(1) }
                else { gameOverButton.opacity(0) }
            }
            Spacer()
        }
        .padding(.top, 50)
        .padding(.horizontal, 20)
    }
}



// MARK: - Buttons/Single Objects

struct TimerView: View {
    
    @ObservedObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        let time = String(format: "%.1f", viewModel.timeLeft)
        
        Text(time)
            .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
    }
}


struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView()
    }
}
