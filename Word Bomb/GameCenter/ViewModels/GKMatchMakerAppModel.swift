///
/// MIT License
///
/// Copyright (c) 2020 Sascha Müllner
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Created by Sascha Müllner on 24.11.20.

import os.log
import Combine
import Foundation
import GameKit
import GameKitUI

class GKMatchMakerAppModel: NSObject, ObservableObject {

    @Published public var showAlert = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""

    @Published public var showAuthentication = false
    @Published public var showInvite = false
    @Published public var showMatch = false
    @Published public var invite: Invite = Invite.zero {
        didSet {
            self.showInvite = invite.gkInvite != nil
            self.showAuthentication = invite.needsToAuthenticate ?? false
        }
    }
    @Published public var gkMatch: GKMatch? {
        didSet {
            self.showInvite = false
            self.showMatch = true
            
        }
    }

    private var cancellableInvite: AnyCancellable?
    private var cancellableMatch: AnyCancellable?
    
    public override init() {
        super.init()
        self.subscribe()
    }

    deinit {
        self.unsubscribe()
    }
    
    func subscribe() {
        self.cancellableInvite = GKMatchManager
            .shared
            .invite
            .sink { (invite) in
                self.invite = invite
        }
        self.cancellableMatch = GKMatchManager
            .shared
            .match
            .sink { (match) in
                self.gkMatch = match.gkMatch
                self.gkMatch?.delegate = self
                self.gkMatch?.chooseBestHostingPlayer { player in
                    print("Best hosting player is: \(String(describing: player?.displayName))")
                    if let playerName = player?.displayName {
                        GKMatchGlobal.hostPlayerName = playerName
                        do {
                            try self.gkMatch?.sendData(toAllPlayers: playerName.data(using: .utf8)!, with: .reliable)
                        } catch {
                            print("could not send hosting player name")
                            print(error.localizedDescription)
                        }
                        
                    }
                }
                
        }
    }

    func unsubscribe() {
        self.cancellableInvite?.cancel()
        self.cancellableMatch?.cancel()
    }

    public func showAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}

extension GKMatchMakerAppModel: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        
        guard let hostPlayerName = String(data: data, encoding: .utf8) else { return }
        print("Received some data")
        GKMatchGlobal.hostPlayerName = hostPlayerName
        
    }
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        print("player changed")
    }
}


