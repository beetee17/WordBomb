//
//  CountryWordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation
import MultipeerConnectivity
import MultipeerKit

class WordBombGameViewModel: NSObject, ObservableObject {
    
    @Published private var model: WordBombGame = WordBombGame()
    @Published private var gameModel: WordGameModel?
    @Published var viewToShow: ViewToShow = .main
    
    @Published var input = ""
    @Published var gameType: GameType?
    var wordGames: [GameMode]

    @Published var selectedPeers: [Peer] = []
    @Published var hostingPeer: Peer?
    @Published var mpcStatus = ""
    

    init(_ wordGames: [GameMode]) {
        self.wordGames = wordGames
    }
    
    func resetPlayers() {
        model.setPlayers(Defaults.players)
    }
    func changeViewToShow(_ view: ViewToShow) {
        viewToShow = view
    }
    
    func selectCustomMode(_ item: Item) {

        let words = decodeJSONStringtoArray(item.words!)
        
        if item.gameType! == "EXACT" {

            selectMode(GameMode(modeName: item.name!, dataFile: nil, queryFile: nil, instruction: item.instruction ?? nil, words: words, queries: nil, gameType: GameType.Exact, id: -1))
        }
        
        else if item.gameType! == "CONTAINS" {
            
            let queries = decodeJSONStringtoArray(item.queries!)
            selectMode(GameMode(modeName: item.name!, dataFile: nil, queryFile: nil, instruction: item.instruction ?? nil, words: words, queries: queries, gameType: GameType.Contains, id: -1))
            
        }
        
    }
    
    func selectMode(_ mode:GameMode) {
        
        
        model.mode = mode
        if mode.dataFile != nil {
            let (data, wordSets) = loadData(mode)
            switch mode.gameType {
            case .Exact: gameModel = ExactWordGameModel(data: data["data"]!, dataDict: wordSets)
                
            case .Contains:
                gameModel = ContainsWordGameModel(data: data["data"]!, queries: data["queries"]!)
                
            case .Reverse:
                gameModel = ReverseWordGameModel(data: data["data"]!, dataDict: wordSets)
            }
        }
        else {
            // Loading custom mode
            switch mode.gameType {
            case .Exact: gameModel = ExactWordGameModel(data: mode.words!, dataDict: [:])
                
            case .Contains:
                gameModel = ContainsWordGameModel(data: mode.words!, queries: mode.queries!)
            case .Reverse: break
            }
            print("CUSTOM GAME! \(gameModel)")
        }

        startGame()
        model.instruction = mode.instruction
   
    }
    
    func startGame() {
        model.clearUI()
        print("host is \(hostingPeer)")
        print("selected peers \(selectedPeers)")
        
//        if gameModel is ContainsWordGameModel || gameModel is ReverseWordGameModel{
//            print("type checked")
            if selectedPeers.count > 0 {
                // only the host should query
                model.query = gameModel!.getRandQuery(input)
                
            } else if hostingPeer == nil {
                // or if device is not in multiplayer game
                print("getting query")
                model.query = gameModel!.getRandQuery(input)
            }
//        }
        
        changeViewToShow(.game)
        model.restartGame()
        startTimer()
    }

    func processInput() {
        
        input = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !(input == "" || model.timeLeft! <= 0) {

            if UserDefaults.standard.string(forKey: "Display Name") ?? MCPeerID.defaultDisplayName == model.currentPlayer.name && selectedPeers.count > 0 {
                // turn for device hosting multiplayer game

                let answer = gameModel!.process(input, model.query)
                model.process(input, answer)
                if .isCorrect == answer {
                    model.query = gameModel!.getRandQuery(input)
                }
            }

            else if let hostPeer = hostingPeer, UserDefaults.standard.string(forKey: "Display Name") ?? MCPeerID.defaultDisplayName == model.currentPlayer.name  {
                // turn for device not hosting but in multiplayer game
                Multipeer.transceiver.send(input, to: [hostPeer])
                print("SENT \(input)")
                
            }
            
            else if hostingPeer == nil && selectedPeers.count == 0 {
                // device not hosting or participating in multiplayer game i.e offline
                let answer = gameModel!.process(input, model.query)
                if .isCorrect == answer {
                    model.query = gameModel!.getRandQuery(input)
                }
                model.process(input, answer)
            }
        }
    }
    
    
    func restartGame() {
        selectMode(model.mode!)
        // may cause issue if mode does not exist (participated in host custom mode and user tries to restart)
    }
    
    func startTimer() {
        print("Timer started")
   
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in

            if .game != self.viewToShow {
                timer.invalidate()
                print("Timer stopped")
            }
            
            else if self.model.timeLeft! <= 0 {
                timer.invalidate()
                self.changeViewToShow(.gameOver)
                print("Timer stopped")
            }
        
            else {
                
                DispatchQueue.main.async {
                    self.model.timeLeft! = max(0, self.model.timeLeft! - 0.1)
                    if self.selectedPeers.count > 0 {
                        // device is hosting a multiplayer game
//                        print("sending model")
                        Multipeer.transceiver.send(self.model, to: self.selectedPeers)
                    }
                }
            }
        }
    }

    func resetInput() {
        input = ""
    }
    
    // check if output is still the same as current to avoid clearing of new outputs
    func clearOutput(_ output: String) { if output == model.output { model.clearOutput() } }
    
    
    // MARK: - Multipeer Functionality

    func disconnectedFrom(_ peer: Peer) {
        print("available \(Multipeer.transceiver.availablePeers)")
        // if non-host device, check if disconnected from hostPeer
        
        // for host device, check if disconnected peer is in selectedPeers
        if let index = selectedPeers.find(peer) {
            // remove from selected and update status
            print("found peer")
            selectedPeers.remove(at: index)
            // notify peer of disconnection
            Multipeer.transceiver.send(false, to: [peer])
        }
        else { print("did not find peer") }
        
        if hostingPeer == nil {
            switch selectedPeers.count == 0 {
            case true:
                mpcStatus = ""
                resetPlayers()
            case false:
                mpcStatus = "Hosting: \(selectedPeers.count) Player(s)"
                setPlayers()
            }
            print("selected peers \(selectedPeers)")
        }
        
        else if peer == hostingPeer {
        
            // reset hostPeer to nil and update status
            hostingPeer = nil
            mpcStatus = "Lost Connection to Host: \(peer.name)"
            resetPlayers()
        
        }
        
        
    }
    
    func toggle(_ peer: Peer) {
        
        // first remove any unavailable peers from selected peers
        for p in selectedPeers {
            if Multipeer.transceiver.availablePeers.find(p) == nil {
                // peer is unavailable
                selectedPeers.remove(at: selectedPeers.firstIndex(of: p)!)
            }
        }
        
        // then do the toggling -> if given peer already selected then remove it and vice versa
        if let index = selectedPeers.find(peer) {
            print("removed \(peer)")
            // notify peer of de-selection
            Multipeer.transceiver.send(false, to: [peer])
            selectedPeers.remove(at: index)
        } else {
            selectedPeers.append(peer)
            // for non-host device to set host peer as sender
            Multipeer.transceiver.send(true, to: [peer])
        }
        
        // after removing -> check if host selected >0 peers
        switch selectedPeers.count > 0 {
        case true:
            mpcStatus = "Hosting: \(selectedPeers.count) Player(s)"
            setPlayers()
        case false:
            mpcStatus = "" // not hosting a game
            resetPlayers()
        }
        
        print("toggled, selected peers \(selectedPeers)")
    }

    func setUpTransceiver() {
        print("Setting up transceiver")
        Multipeer.transceiver.peerDisconnected = { peer in
            
            DispatchQueue.main.async {
                print("Disconnected from \(peer)")
                self.disconnectedFrom(peer) }
        }
            
        
        Multipeer.transceiver.peerRemoved = { peer in
            DispatchQueue.main.async {
                print("\(peer) Removed")
                self.disconnectedFrom(peer) }
        }
        Multipeer.transceiver.peerAdded = { peer in
            DispatchQueue.main.async {
                print("\(peer) Added")
                
            }
        }
        
        Multipeer.transceiver.peerConnected = { peer in print("Connected to \(peer.name)") }
        
        //participants receiving model from host
        Multipeer.transceiver.receive(WordBombGame.self) { payload, sender in
//            print("Got model from host \(sender.name)! \(payload)")
            self.model = payload
        }
        // participant successfully connected to peer and received data from host
        Multipeer.transceiver.receive(Bool.self) { payload, sender in
            print("Got boolean from host \(sender.name)! \(payload)")
            switch payload {
            case true: // host selected this peer to join game
                self.hostingPeer = sender
                self.mpcStatus = "Connected to Host: \(sender.name)"
                
            case false: // host deselected this peer
                self.hostingPeer = nil
                self.mpcStatus = ""
            }
            
        }
        
        // host receiving inputs from participants
        Multipeer.transceiver.receive(String.self) { payload, sender in
            print("Got input from player \(sender.name)! \(payload)")
            self.input = payload
            self.processPeerInput()
        }
        
    }
//    func testHostConnection() {
//        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
//              print("Time is Over")
//           }
//           Login.getUSerAuthenticaiton(email: "abc@zyf.com", password: "123456789", completion: {_,_ in
//                   print("Reponse")
//               timer.invalidate()
//           })
//    }
//
    func processPeerInput() {
        input = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        print("processing \(input)")
        let answer = gameModel!.process(input, model.query)
        if case .isCorrect = answer {
            model.query = gameModel!.getRandQuery(input)
        }
        model.process(input, answer)
        resetInput()
    }
    
    func setPlayers() {
        
        var players: [Player] = [Player(name: UserDefaults.standard.string(forKey: "Display Name") ?? MCPeerID.defaultDisplayName, ID: 0)]
        
        for i in selectedPeers.indices {
            let player = Player(name: selectedPeers[i].name, ID: i+1)
            players.append(player)
        }
        print("players set \(players)")
        model.setPlayers(players)

    }

    
    
    // to allow contentView to read model's value and update
    var currentPlayer: String { model.currentPlayer.name }
    
    var instruction: String? { model.instruction }
    
    var query: String? { model.query }
    
    var timeLeft: Float { model.timeLeft! }
    
    var output: String { model.output }

    
        
}


