//
//  ContentView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI
import MultipeerKit
import GameKit

struct ContentView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    
    var body: some View {
        ZStack {

            Color("Background")
                .ignoresSafeArea(.all)
//            RadialGradient(colors: [.white, .gray], center: .center, startRadius: Device.height/3, endRadius: Device.height/1.3).ignoresSafeArea(.all)
            
            GameView()
            MPCText()
            
            
                
        }
        .onAppear() {
            Multipeer.transceiver.resume()
            viewModel.setUpTransceiver()
        }
        
    }
   
}






struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {

       ContentView()
            .environmentObject(WordBombGameViewModel(.main))
            .environmentObject(MultipeerDataSource(transceiver: Multipeer.transceiver))
       
    }
}


