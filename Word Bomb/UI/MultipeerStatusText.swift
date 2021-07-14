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
        VStack {
            
            let mpcStatusText = Text(viewModel.mpcStatus)
            
            let text = viewModel.mpcStatus.lowercased()
            switch text.contains("connected to") || text.contains("are host")  || text.contains("discoverable") {
            case true:
                mpcStatusText.foregroundColor(.green)
                
            case false:
                mpcStatusText.foregroundColor(.red)
                
            }

            Spacer()

        }
        .font(.caption)
        .environmentObject(mpcDataSource)
    }
}


struct MultipeerStatusText_Previews: PreviewProvider {
    static var previews: some View {
        MPCText()
    }
}

