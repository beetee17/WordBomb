//
//  MultiplayerDisplayName.swift
//  Word Bomb
//
//  Created by Brandon Thio on 9/7/21.
//

import SwiftUI
import MultipeerKit
import MultipeerConnectivity
import CoreData


struct MultiplayerDisplayName: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource

    @State var newDisplayName = UserDefaults.standard.string(forKey: "Display Name") ?? MCPeerID.defaultDisplayName
    
    @State var savedDisplayName = false
  
    var body: some View {
        
        VStack {
           
                
            TextField(UserDefaults.standard.string(forKey: "Display Name") ?? MCPeerID.defaultDisplayName, text: $newDisplayName) { isEditing in }
                onCommit: {
                    if newDisplayName != UserDefaults.standard.string(forKey: "Display Name") ?? MCPeerID.defaultDisplayName {
                        
                        UserDefaults.standard.set(newDisplayName, forKey: "Display Name")
                        print("save \(newDisplayName) to settings")
                        savedDisplayName.toggle()
                        
                    }
            
                }
                .font(Font.system(size: 32, design: .default))
                .multilineTextAlignment(.center)
    
            //top align text field
            Spacer()
        }
        .padding(.top, 100)
        .alert(isPresented: $savedDisplayName, content: { Alert(title: Text("Saved Display Name!"),
               message: Text("Changes will take effect on next restart of the game"),
               dismissButton: .default(Text("OK"))
                   {
                       print("dismissed")
                       savedDisplayName = false
                   })
   })
        
        
    }
    
}

struct MultiplayerDisplayName_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerDisplayName()
    }
}
