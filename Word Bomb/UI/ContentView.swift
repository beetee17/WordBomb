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
            RadialGradient(colors: [.white, .gray], center: .center, startRadius: UIScreen.main.bounds.height/3, endRadius: UIScreen.main.bounds.height/1.3).ignoresSafeArea(.all)
            
            GameView()
            MPCText()

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

       ContentView()
            .environmentObject(WordBombGameViewModel(.main))
            .environmentObject(MultipeerDataSource(transceiver: Multipeer.transceiver))
       
    }
}


