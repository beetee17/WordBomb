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
            
            Button(action: {
                print("RESUME!")
                withAnimation {
                    viewModel.changeViewToShow(.game)
                    viewModel.startTimer()
                } })
            {
                HStack {
                    Image(systemName: "play")
                    Text("RESUME")
                }
            }
            .buttonStyle(MainButtonStyle())
            
            Button(action: {
                print("Restart Game")
                viewModel.restartGame()
            }) {
                HStack {
                    Image(systemName: "gobackward")
                    Text("RESTART")
                }
            }
            .buttonStyle(MainButtonStyle())
            
            
            Button(action: {
                print("QUIT!")
                withAnimation {
                    viewModel.changeViewToShow(.main) }
            }) {
                HStack {
                    Image(systemName: "flag")
                    Text("QUIT")
                }
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
