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
                ForEach(GameType.allCases, id: \.self) { type in
                    Button(type.rawValue.uppercased()) {
                        
                        viewModel.gameType = type
                        withAnimation { viewModel.changeViewToShow(.modeSelect) }
                        
                    }
                    .buttonStyle(MainButtonStyle())
                    
                }
                
            }
            Game.backButton {
                withAnimation { viewModel.changeViewToShow(.main) } 
            }
        }
        .helpSheet()
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
