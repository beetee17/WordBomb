//
//  ContentView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import SwiftUI
import MultipeerKit

#if canImport(UIKit)
// To force SwiftUI to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


struct ContentView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    
    var body: some View {
        ZStack {
            MPCText()
            
            GameView()
            
        }
        .onAppear() {
            Multipeer.reconnect(mpcDataSource)
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


