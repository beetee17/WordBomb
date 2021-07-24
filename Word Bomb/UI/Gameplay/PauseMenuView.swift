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
        .helpSheet(title: "Game Play",
                   headers: ["How to Play"],
                   content: ["Players are tasked to form a word according to the game mode's instruction before their time runs out, which loses them a life. The last player standing is declared the winner of the game!\n\nIn a Classic game, players are given a randomly generated syllable, and your task is to come up with a valid word that contains the syllable.\n\nIn an Exact game, you must come up with an answer that is found in the mode's database. For example, a database of countries would mean players are only allowed to name countries. You can create your own custom database to play with friends!\n\nA Reverse game is similar to the Exact game, with the added constraint that the answer must start with the ending letter of the previous player's answer."])
    }
}

struct PauseMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        PauseMenuView()
    }
}
