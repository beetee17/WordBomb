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
    
    static func disconnect(_ mpcDataSource: MultipeerDataSource, _ viewModel: WordBombGameViewModel) {
        mpcDataSource.transceiver.stop()
        for peer in viewModel.selectedPeers {
            viewModel.toggle(peer)
        }

        print("manual disconnect, selected peers: \(viewModel.selectedPeers)")
        viewModel.hostingPeer = nil
    }
    
    static func reconnect(_ mpcDataSource: MultipeerDataSource) {
        mpcDataSource.transceiver.resume()
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

