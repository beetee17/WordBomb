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
}
