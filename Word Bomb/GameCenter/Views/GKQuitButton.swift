//
//  GKQuitButton.swift
//  Word Bomb
//
//  Created by Brandon Thio on 23/7/21.
//

import SwiftUI
import GameKitUI

struct GKQuitButton: View {
    var body: some View {
        Button(action: {
            GKMatchManager.shared.cancel()
            GameCenter.hostPlayerName = nil
            Game.viewModel.resetGameModel()
            print("Manual Quit, isGKOnline \(GameCenter.isOnline)")
        }) {
            HStack {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
                    
                Text("Quit")
            }
            .foregroundColor(.white)
            
        }
    }
}

struct GKQuitButton_Previews: PreviewProvider {
    static var previews: some View {
        GKQuitButton()
    }
}
