//
//  ContentView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI
import MultipeerKit

struct ContentView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    
    var body: some View {
        ZStack {
            MPCText()
            
            GameView()
            
        }
        .onAppear() {
            Multipeer.transceiver.resume()
            viewModel.setUpTransceiver()
        }
        .environmentObject(viewModel)
        .environmentObject(mpcDataSource)
    }
}






struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {

    
    Group {
           ContentView().colorScheme(.light)
//               ContentView(viewModel: game).colorScheme(.dark)
       }
    }
}


