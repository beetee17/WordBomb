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
    @State var pauseMenu = false
    
    
    
    var body: some View {
        
        switch viewModel.viewToShow {
            
        case .main: MainView()
        case .gameTypeSelect: GameTypeSelectView()
        case .modeSelect: ModeSelectView()
        case .multipeer: LocalMultiplayerView()
        case .peersView: LocalPeersView()
            
        default:
            ZStack {
                
                GamePlayView()
                
                
                PauseMenuView()
                    .scaleEffect(.pauseMenu == viewModel.viewToShow ? 1 : 0)
            }
            
        }
        
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = WordBombGameViewModel(.game)
        game.startGame(mode: Defaults.WordGame)
        
        return Group {
            GameView().environmentObject(game)
        }
    }
}
