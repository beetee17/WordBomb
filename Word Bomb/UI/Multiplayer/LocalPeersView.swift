//
//  LocalPeersView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 9/7/21.
//

import SwiftUI
import MultipeerKit

enum ActiveAlert {
    case host, notConnected
}

struct LocalPeersView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    
    @State var showAlert = false
    @State var activeAlert: ActiveAlert = .notConnected
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                Text("Peers").font(.system(.headline)).padding()

                List {
                    ForEach(mpcDataSource.availablePeers) { peer in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(peer.isConnected ? .green : .gray)
                            
                            Text(peer.name)

                            Spacer()
                            if self.viewModel.selectedPeers.contains(peer) { Image(systemName: "checkmark") }

                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // selects peer
                            if peer.isConnected {
                                viewModel.toggle(peer)
                                if viewModel.selectedPeers.count > 0 {
                                    activeAlert = .host
                                    showAlert = true
                                }
                            }
                            else {
                                activeAlert = .notConnected
                                showAlert = true
                            }

                        }
                    }
                }
                
            }
        }
        .environmentObject(mpcDataSource)
        // TODO: - Change to show only once when selecting multiple peers
        .alert(isPresented: $showAlert,
               content: {
                
                switch activeAlert {
                case .host:
                    return Alert(title: Text("You are the host!"),
                                    message: Text("Connected devices can see your game!"),
                                    dismissButton: .default(Text("OK"))
                                        {
                                            print("dismissed")
                                            showAlert = false
                                        })
                case .notConnected:
                    return Alert(title: Text("Unable to Connect"),
                                     message: Text("You may only select connected peers!"),
                                     dismissButton: .default(Text("OK"))
                                         {
                                             print("dismissed")
                                             showAlert = false
                                         })
                
                }
               })
    }
}


        
    

//struct LocalPeersView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalPeersView()
//    }
//}
