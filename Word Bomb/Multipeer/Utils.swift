//
//  Multipeer.swift
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
    
    static var selectedPeers = [Peer]()
    static var hostingPeer: Peer? = nil
    
    static var isHost: Bool { selectedPeers.count > 0 }
    static var isNonHost: Bool { hostingPeer != nil && selectedPeers.count == 0 }
    static var isOnline: Bool { isHost || isNonHost }
    static var isOffline: Bool { !isOnline }
    
    
//    static func reconnect() {
//
//        // RISKY????
//
//        print("reconnect")
//        DispatchQueue.main.async {
//
//            // re-init new transceiver and dataSource
//            let newTransceiver = MultipeerTransceiver(configuration: MultipeerConfiguration(serviceType: "word-bomb", peerName: UserDefaults.standard.string(forKey: "Display Name")!, defaults: .standard, security: .default, invitation: .automatic))
//
//            dataSource = MultipeerDataSource(transceiver: newTransceiver)
//            transceiver = newTransceiver
//
//            // start new transceiver
//            transceiver.resume()
//
//        }
//    }
    static func reconnect() {
        transceiver.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            transceiver.resume()
        }
    }
}
