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

    var body: some View {
        
        switch viewModel.viewToShow {
        
            case .main: MainView()
            case .gameTypeSelect: GameTypeSelectView()
            case .modeSelect: ModeSelectView()
            case .pauseMenu: PauseMenuView()
            case .multipeer: LocalMultiplayerView()
            case .peersView: LocalPeersView()
                
            default: // game or gameOver
                ZStack{
                    Color.clear
                    TopBarView()

                    InputView()
                    PlayerView()
                    OutputText()
                    
                    // for debugging
                  
//                    Button("Disconnect") {
//                        
//                        Multipeer.disconnect(viewModel)
//                        }
                        
                }
                .ignoresSafeArea(.all)
            }
        
        }
    
    }


struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView()
    }
}
