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
    
    
    static var transceiver = MultipeerTransceiver(configuration: MultipeerConfiguration(serviceType: "word-bomb", peerName: UserDefaults.standard.string(forKey: "Display Name")!, defaults: .standard, security: .default, invitation: .automatic))
    
    static var dataSource = MultipeerDataSource(transceiver: transceiver)
    
    static func reconnect() {
        
        // RISKY????

        print("reconnect")
        DispatchQueue.main.async {
            
            // re-init new transceiver and dataSource
            let newTransceiver = MultipeerTransceiver(configuration: MultipeerConfiguration(serviceType: "word-bomb", peerName: UserDefaults.standard.string(forKey: "Display Name")!, defaults: .standard, security: .default, invitation: .automatic))
            
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

extension Array where Element == Player {
    func find(_ player: Player) -> Int? {
        for i in self.indices {
            if self[i].id == player.id { return i }
        }
        return nil
    }
    
    func numPlaying() -> Int {
        var num = 0
        for player in self {
            if !player.ranOutOfTime { num = num+1 }
        }
        
        return num
    }
    
    func reset() {
        for player in self {
            player.reset()
        }
    }
}
