//
//  MultipeerStatusText.swift
//  Word Bomb
//
//  Created by Brandon Thio on 7/7/21.
//

import SwiftUI
import MultipeerKit

struct MPCText: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    
    var body: some View {
        VStack() {
            
            let mpcStatusText = Text(viewModel.mpcStatus)
            
            let text = viewModel.mpcStatus.lowercased()
            switch text.contains("connected to") || text.contains("hosting")  || text.contains("discoverable") {
            case true:
                mpcStatusText.foregroundColor(.green)
                
            case false:
                mpcStatusText.foregroundColor(.red)
                
            }
            Spacer()

        }
        .offset(x: 0, y: -10)
        .font(.caption)
        .environmentObject(mpcDataSource)
    }
}


struct MultipeerStatusText_Previews: PreviewProvider {
    static var previews: some View {
        MPCText()
    }
}

