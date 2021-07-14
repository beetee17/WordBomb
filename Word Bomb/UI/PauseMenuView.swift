//
//  PauseMenuView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI


struct PauseMenuView: View {
    // Preented when game is paused
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        VStack(spacing: 100) {
            // RESUME, RESTART, QUIT buttons
            
            Button("RESUME")  {
                print("RESUME!")
                withAnimation {
                    viewModel.changeViewToShow(.game)
                    viewModel.startTimer()
                }
            }
            .buttonStyle(MainButtonStyle())
            
            Button("Restart") {
                print("Restart Game")
                viewModel.restartGame()
            }
            .buttonStyle(MainButtonStyle())
            
 
            Button("QUIT") {
                print("QUIT!")
                withAnimation {
                    viewModel.changeViewToShow(.main) }
            }
            .buttonStyle(MainButtonStyle())
            
        }
    }
}

struct PauseMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        PauseMenuView()
    }
}
