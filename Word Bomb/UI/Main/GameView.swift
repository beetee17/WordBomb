//
//  GameView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI
import CoreData
import MultipeerKit
import GameKit
import GameKitUI

struct GameView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    @State var pauseMenu = false
    
    

    var body: some View {
        
        switch viewModel.viewToShow {
            
        case .main: MainView()
        case .gameTypeSelect: GameTypeSelectView()
        case .modeSelect: ModeSelectView(gameType: viewModel.gameType!)
        case .multipeer: LocalMultiplayerView()
        case .peersView: LocalPeersView()
        case .GKMain:
            GKContentView()
        case .GKLogin:
            AuthenticationView()
        
        default:
            ZStack {

                GamePlayView(gkMatch: nil)
                
                PauseMenuView()
                    .helpSheet()
                    .scaleEffect(.pauseMenu == viewModel.viewToShow ? 1 : 0.01)
                    .ignoresSafeArea(.all)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = WordBombGameViewModel(.game)
        game.startGame(mode: Game.WordGame)
        
        return Group {
            GameView().environmentObject(game)
        }
    }
}
