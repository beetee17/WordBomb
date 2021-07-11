//
//  MPC.swift
//  Word Bomb
//
//  Created by Brandon Thio on 5/7/21.
//

import Foundation
import MultipeerKit
import MultipeerConnectivity


struct Multipeer {
    
    
    static var transceiver = MultipeerTransceiver(configuration: MultipeerConfiguration(serviceType: "word-bomb", peerName: UserDefaults.standard.string(forKey: "Display Name") ?? MCPeerID.defaultDisplayName, defaults: .standard, security: .default, invitation: .automatic))
    
    static var dataSource = MultipeerDataSource(transceiver: transceiver)
    
    static func disconnect(_ viewModel: WordBombGameViewModel) {
        print("manual disconnect")
        
        transceiver.stop()
        
        if viewModel.selectedPeers.count > 0 {
            viewModel.selectedPeers = []
            print("selected peers: \(viewModel.selectedPeers)")
            viewModel.resetPlayers()
        }
        
        viewModel.mpcStatus = ""
        viewModel.hostingPeer = nil
    }
    
    static func reconnect() {
        
        // RISKY????

        print("reconnect")
        DispatchQueue.main.async {
            // re-init new transceiver and dataSource
            let newTransceiver = MultipeerTransceiver(configuration: MultipeerConfiguration(serviceType: "word-bomb", peerName: UserDefaults.standard.string(forKey: "Display Name") ?? MCPeerID.defaultDisplayName, defaults: .standard, security: .default, invitation: .automatic))
            dataSource = MultipeerDataSource(transceiver: newTransceiver)
            transceiver = newTransceiver
            // start new transceiver
            transceiver.resume()
            
        }
        
        
    }
}

extension Array where Element == Peer {
    func find(_ peer: Peer) -> Int? {
        for i in self.indices {
            if self[i].id == peer.id { return i }
        }
        return nil
    }
}

