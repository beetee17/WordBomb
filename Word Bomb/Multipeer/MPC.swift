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
