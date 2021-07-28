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
            Game.mainButton(label: "RESUME", systemImageName: "play") {
                withAnimation {
                    viewModel.resumeGame()
                }
            }
            Game.mainButton(label: "RESTART", systemImageName: "gobackward") {
                if !Multipeer.isNonHost && !GameCenter.isNonHost {
                    print("Restart Game")
                    viewModel.restartGame()
                }
            }
            
            Game.mainButton(label: "QUIT", systemImageName: "flag") {
                withAnimation {
                viewModel.changeViewToShow(.main) }
                
            }
            
        }
    }
}

struct PauseMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        PauseMenuView()
    }
}
