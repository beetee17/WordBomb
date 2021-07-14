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
                let screen = UIScreen.main.bounds
 
                VStack {
                    
                    TopBarView()
                        .offset(x: 0, y: 60)
                        .padding(.horizontal, 5)
                        .ignoresSafeArea(.all)

                    PlayerView(numPlaying: viewModel.players.numPlaying())
                    
                    Spacer()
                }
            
                VStack {
                    Spacer()
                    
                    instructionText.ignoresSafeArea(.keyboard)
                    InputView()
                    queryText.ignoresSafeArea(.keyboard)
                    
                    ZStack {
                        Text("INVISIBLE PLACEHOLDER TEXT")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .textCase(.uppercase)
                            .opacity(0)
                        OutputText()
                    }

                    Spacer()
                }
                .padding(.top, screen.height*0.3)
            
            }
            
        }
    
    }

}


struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView().environmentObject(WordBombGameViewModel(.game))
    }
}
