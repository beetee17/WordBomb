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

                TimerView().offset(x: 0, y: 20)
                
                Spacer()
  
                if .gameOver == viewModel.gameState { gameOverButton.opacity(1) }
                else { gameOverButton.opacity(0) }
            }
            .padding(.horizontal, 20)
        
    }
}



// MARK: - Buttons/Single Objects

struct TimerView: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {

        Image(updateFrame(numTotalFrames: 27, timeLeft: viewModel.timeLeft, timeLimit: viewModel.timeLimit))
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .overlay(Text(String(format: "%.1f", viewModel.timeLeft)).foregroundColor(.white).offset(x: 0, y: 20))
    
        
    }
    
    private func updateFrame(numTotalFrames: Int, timeLeft: Float, timeLimit: Float) -> String {
        let frameNumber = numTotalFrames - Int(timeLeft / (timeLimit / Float(numTotalFrames)))
        if frameNumber >= 10 {
            print("frame_\(frameNumber)_delay-0.08s")
            return "frame_\(frameNumber)_delay-0.08s"
        }
        else {
            return "frame_0\(frameNumber)_delay-0.08s"
        }
    }
        
}



struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView().environmentObject(WordBombGameViewModel())
    }
}
