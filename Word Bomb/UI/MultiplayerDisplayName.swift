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
    
    @State var newDisplayName = UserDefaults.standard.string(forKey: "Display Name")!
    
    @State var changeNameWarning = false
  
    var body: some View {
        
        VStack {
           
            PlayerAvatar(playerName: newDisplayName)
            
            TextField(UserDefaults.standard.string(forKey: "Display Name")!, text: $newDisplayName) { isEditing in }
                onCommit: {
                    newDisplayName = newDisplayName.trim()
                    if newDisplayName != UserDefaults.standard.string(forKey: "Display Name")! {
   
                        changeNameWarning = true
                        
                    }
            
                }
                .font(Font.system(size: 32, design: .default))
                .multilineTextAlignment(.center)
    
            //top align text field
            Spacer()
        }
        .padding(.top, UIScreen.main.bounds.height*0.1)
        .alert(isPresented: $changeNameWarning,
               content: { Alert(title: Text("Warning"),
                                message: Text("Changing your display name while connected to other devices may cause connection issues."),
                                primaryButton: .default(Text("Save")) {
                                    print("dismissed")
                                    UserDefaults.standard.set(newDisplayName, forKey: "Display Name")
                                    
                                    viewModel.disconnect()
                                    Multipeer.reconnect()
                                    changeNameWarning = false
                   
                                   print("saved \(newDisplayName) to settings")
                                },
                                secondaryButton: .default(Text("Cancel")) {
                                    print("Cancelled")
                                    // reset edited display name to current name
                                    newDisplayName = UserDefaults.standard.string(forKey: "Display Name")!
                                    changeNameWarning = false
                                })
                            })

    }
    
}

struct MultiplayerDisplayName_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerDisplayName()
    }
}
