//
//  GameTypeSelect.swift
//  Word Bomb
//
//  Created by Brandon Thio on 10/7/21.
//

import SwiftUI


struct GameTypeSelectView: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        VStack(spacing:100) {
            
            SelectGameTypeText()
            
            VStack(spacing: 50) {
                ForEach(Game.types) { gameType in
                    Button(gameType.name) {
                        
                        viewModel.gameType = gameType
                        withAnimation { viewModel.changeViewToShow(.modeSelect) }
                        
                    }
                    .buttonStyle(MainButtonStyle())
                    
                }
                
            }
            Button(action: { withAnimation { viewModel.changeViewToShow(.main) } }) {
                Image(systemName: "arrow.backward")
                    .font(Font.title.bold())
                    .foregroundColor(.white)
            }
        }
        .helpSheet(title: "Game Types",
                   headers: ["About", "Classic", "Exact", "Reverse"],
                   content: ["Word Bomb is a multiplayer word game that allows you to test your quick-thinking and general knowledge of vocabulary or other custom categories such as countries.\n\nThere are 3 game types currently implemented: Classic, Exact and Reverse.\n\nIn all cases, players are tasked to form a word according to the game mode's instruction before their time runs out which loses them a life. The last player standing is declared the winner of the game!",
                             "In a Classic game, players are given a random syllable, and your task is to come up with a valid word that contains the syllable.",
                             "In an Exact game, you must come up with an answer that is found in the database. For example, the database of countries would mean players are only allowed to name countries. You can create your own custom database to play with friends!",
                             "A Reverse game is similar to the Exact game, with the added constraint that the answer must start with the ending letter of the previous player's answer."])
        .frame(width: Device.width, height: Device.height, alignment: .center)
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .environmentObject(viewModel)
    }
}


struct SelectGameTypeText: View {
    
    var body: some View {
        
        Text("Select Game Type")
            .fontWeight(.bold)
            .font(.largeTitle)
        
    }
}


struct GameTypeSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameTypeSelectView().environmentObject(WordBombGameViewModel())
    }
}
