//
//  GameView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI
import CoreData
import MultipeerKit

struct GameView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    
    var instructionText: some View {
        viewModel.instruction.map { Text($0)
            .boldText()
            
        }
    }
    var queryText: some View {
        viewModel.query.map { Text($0).boldText() }
    }

    var body: some View {
        
        switch viewModel.viewToShow {
        
        case .main: MainView()
        case .gameTypeSelect: GameTypeSelectView()
        case .modeSelect: ModeSelectView()
        case .pauseMenu: PauseMenuView()
        case .multipeer: LocalMultiplayerView()
        case .peersView: LocalPeersView()
                
        case .game: // game or gameOver
            ZStack {
                
                Color.clear

                InputView().padding(.top, 225)
                
                PlayerView()
                    .ignoresSafeArea(.keyboard)
                    .padding(.bottom, 250)
                
                TopBarView()
                    .padding(.top, 40)
                    .ignoresSafeArea(.all)

                VStack {
                    
                    instructionText
                    queryText

                }
                .ignoresSafeArea(.keyboard)
                .padding(.top, 150)
                
                OutputText()
                    .padding(.top, 200)

            }
        }
    
    }

}


struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView().environmentObject(WordBombGameViewModel(.game))
    }
}
