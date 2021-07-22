//
//  CountryWordBombGame.swift
//  Word Bomb
//
//  Created by Brandon Thio on 1/7/21.
//

import Foundation
import MultipeerConnectivity
import MultipeerKit
import GameKit
import GameKitUI


class WordBombGameViewModel: NSObject, ObservableObject {
    
    @Published private var model: WordBombGame = WordBombGame()
    @Published private var gameModel: WordGameModel? = nil
    @Published var viewToShow: ViewToShow = .main
    
    @Published var input = ""
    @Published var forceHideKeyboard = true
    @Published var gameType: GameType? = nil
    
    @Published var mpcStatus = ""
    
    init(_ viewToShow: ViewToShow = .main) {
        self.viewToShow = viewToShow

    }
    func updateGameSettings() {
        model = WordBombGame()
        if selectedPeers.count > 0 {
            setOnlinePlayers()
        }
    }
    
    func changeViewToShow(_ view: ViewToShow) {
        viewToShow = view
        if .game == viewToShow {
            forceHideKeyboard = false
        }
        else {
            forceHideKeyboard = true
        }
    }
    
    func pauseGame() {
        if Multipeer.isHost {
            Multipeer.transceiver.send("$PAUSED_GAME$", to: selectedPeers)
        }
        changeViewToShow(.pauseMenu)
        Game.stopTimer()
    }
    
    func resumeGame() {
        if Multipeer.isHost {
            Multipeer.transceiver.send("$PLAYING_GAME$", to: selectedPeers)
        }
        changeViewToShow(.game)
        startTimer()
    }
    
    func restartGame() {
        if gameModel != nil {
            
            gameModel!.reset()
            
            if Multipeer.isHost {
                setOnlinePlayers()
            }
            
            model.handleGameState(.initial,
                                  data: ["query" : gameModel!.getRandQuery(input),
                                         "instruction" : model.instruction as Any])
            changeViewToShow(.game)
            startTimer()
            
        }
        else {
            print("mode not found")
            // present some alert to user
        }
    }
    
    func selectCustomMode(_ item: Item) {
        
        let words = decodeJSONStringtoArray(item.words!)
        
        if item.gameType! == "EXACT" {
            
            startGame(mode: GameMode(modeName: item.name!, dataFile: nil, queryFile: nil, instruction: item.instruction ?? nil, words: words, queries: nil, gameType: Game.types[.Classic], id: -1))
        }
        
        else if item.gameType! == "CONTAINS" {
            
            let queries = decodeJSONStringtoArray(item.queries!)
            startGame(mode: GameMode(modeName: item.name!, dataFile: nil, queryFile: nil, instruction: item.instruction ?? nil, words: words, queries: queries, gameType: Game.types[.Classic], id: -1))
            
        }
        
    }
    
    func startGame(mode: GameMode) {
        
        
        // process the gameMode by initing the appropriate WordGameModel
        
        if mode.dataFile != nil {
            let (words, wordSets) = loadWordSets(mode)
            switch mode.gameType.type {
            case .Exact: gameModel = ExactWordGameModel(data: words, dataDict: wordSets)
                
            case .Classic:
                let queries = loadSyllables(mode)
                gameModel = ContainsWordGameModel(data: words, queries: queries)
                
            case .Reverse:
                gameModel = ReverseWordGameModel(data: words, dataDict: wordSets)
            }
        }
        else {
            // Loading custom mode
            switch mode.gameType.type {
            case .Exact: gameModel = ExactWordGameModel(data: mode.words!, dataDict: [:])
                
            case .Classic:
                break
                //                gameModel = ContainsWordGameModel(data: mode.words!, queries: mode.queries!)
            case .Reverse:
                gameModel = ReverseWordGameModel(data: mode.words!, dataDict: [:])
            }
            print("CUSTOM GAME! \(String(describing: gameModel))")
        }
        
        
        print("host is \(String(describing: hostingPeer))")
        print("selected peers \(selectedPeers)")
        
        if Multipeer.isHost || Multipeer.isOffline {
            print("getting query")
            // should query only if device is not in multiplayer game or is hosting a game
            model.handleGameState(.initial,
                                  data: ["query" : gameModel!.getRandQuery(nil),
                                         "instruction" : mode.instruction as Any])
        }
        else { model.handleGameState(.initial,
                                     data: ["instruction" : mode.instruction as Any]) }
        
        changeViewToShow(.game)
        startTimer()

    }

    func processInput() {
        
        
        input = input.lowercased().trim()
        
        if !(input == "" || model.timeLeft <= 0) {
            
            if Multipeer.isHost && isMyTurn {
                // turn for device hosting multiplayer game
                
                let response = gameModel!.process(input, model.query)
                
                model.handleGameState(.playerInput, data: ["input" : input, "response" : response])
            }
            
            else if Multipeer.isNonHost && isMyTurn  {
                // turn for device not hosting but in multiplayer game
                Multipeer.transceiver.send(input, to: [hostingPeer!])
                print("SENT \(input)")
                
            }
            
            
            else if Multipeer.isOffline {
                // device not hosting or participating in multiplayer game i.e offline
                let response = gameModel!.process(input, model.query)
                
                model.handleGameState(.playerInput, data: ["input" : input, "response" : response])
            }
        }
        
    }

    func startTimer() {
        print("Timer started")
        
        guard Game.timer == nil else { return }
        Game.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] _ in
            
            
            DispatchQueue.main.async {
                model.timeLeft = max(0, model.timeLeft - 0.1)
                
                if Multipeer.isHost {
                    let roundedValue = Int(round(model.timeLeft * 10))
                    if roundedValue % 5 == 0 {
                        Multipeer.transceiver.send(["Updated Time Left" : model.timeLeft], to: selectedPeers)
                    }
                }
            }
            
            if model.timeLeft <= 0 && !Multipeer.isNonHost {
                
                DispatchQueue.main.async {
                    self.model.handleGameState(.playerTimedOut)
                }
            }
        }
    }
    
    
    
    // check if output is still the same as current to avoid clearing of new outputs
    func clearOutput(_ output: String) { if output == model.output { model.clearOutput() } }

    // to allow contentView to read model's value and update
    var playerQueue: [Player] { model.playerQueue }
    
    var currentPlayer: Player { model.currentPlayer }
    
    var livesLeft: Int { model.livesLeft }
    
    var instruction: String? { model.instruction }
    
    var query: String? { model.query }
    
    var timeLimit: Float { model.timeLimit }
    
    var timeLeft: Float { model.timeLeft }
    
    var output: String { model.output }
    
    var gameState: GameState { model.gameState }
    
    var animateExplosion: Bool {
        
        get { model.animateExplosion }
        set { model.animateExplosion =  newValue }
    }
    
   
}




extension WordBombGameViewModel {
    
    var selectedPeers: [Peer] {
        get { Multipeer.selectedPeers }
        set { Multipeer.selectedPeers = newValue }
    }
    var hostingPeer: Peer? {
        get { Multipeer.hostingPeer }
        set { Multipeer.hostingPeer = newValue }
    }
    var isMyTurn: Bool { UserDefaults.standard.string(forKey: "Display Name")! == model.currentPlayer.name }
    
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
                model = .init()
            case false:
                mpcStatus = "Hosting: \(selectedPeers.count) Player(s)"
                setOnlinePlayers()
            }
            print("selected peers \(selectedPeers)")
        }
        
        else if peer == hostingPeer {
            
            // reset hostPeer to nil and update status
            hostingPeer = nil
            mpcStatus = "Lost Connection to Host: \(peer.name)"
            model = .init()
            
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
        switch Multipeer.isHost {
        case true:
            mpcStatus = "Hosting: \(selectedPeers.count) Player(s)"
            setOnlinePlayers()
        case false:
            mpcStatus = "" // not hosting a game
            model = .init()
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
            DispatchQueue.main.async {
                print("Got model from host \(sender.name)!")
                
                self.model = payload
                self.model.currentPlayer = self.model.playerQueue[0]
                for player in self.playerQueue {
                    print("\(player.name): \(player.livesLeft) lives")
                }
                self.changeViewToShow(.game)
                self.startTimer()
            }
            
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
        
        // send model at .initial game state to signify start of game by host
        // every 0.5s -> update time to keep in sync
        // on input -> send new query and output
        Multipeer.transceiver.receive([String:String].self) { payload, sender in
            
            if let input = payload["input"] {
                let newQuery: String? = nil
                
                print("processing input/response data from host")
                self.model.handleGameState(.playerInput,
                                           data: ["input" : input,
                                                  "response" : (payload["status"], newQuery)])
            }
            
            if let query = payload["query"] {
                print("received new query from host \(payload)")
                self.model.query = query
            }
            
            
        }
        Multipeer.transceiver.receive([String: Float].self) { payload, sender in
            print("got time from host")
            if let timeLeft = payload["Updated Time Left"] {
                self.model.timeLeft = timeLeft
            }
            
            if let newTimeLimit = payload["New Time Limit"] {
                print("receive new time limit from host \(payload)")
                self.model.timeLeft = newTimeLimit
            }
        }
        
        
        Multipeer.transceiver.receive(String.self) { payload, sender in
            
            switch payload {
            case "Current Player Timed Out":
                print("got player timed out update from host")
                self.model.handleGameState(.playerTimedOut)
                
            case "$PAUSED_GAME$":
                Game.stopTimer()
            case "$PLAYING_GAME$":
                self.startTimer()
                
            default:
                // host receiving inputs from participants
                print("Got data from non-host device \(sender.name)! \(payload)")
                self.processPeerInput(payload)
            }
            
        }
        
    }
    
    func processPeerInput(_ input: String) {

        print("processing \(input)")
        let response = gameModel!.process(input.lowercased().trim(), model.query)
        
        model.handleGameState(.playerInput, data: ["input" : input, "response" : response])

    }
    
    func setOnlinePlayers() {
        
        var players: [Player] = [Player(name: UserDefaults.standard.string(forKey: "Display Name")!)]
        
        for i in selectedPeers.indices {
            let player = Player(name: selectedPeers[i].name)
            players.enqueue(player)
        }
        print("players set \(players)")
        model = .init(players)
        
    }
    
    func setGKPlayers(_ gkPlayers: [GKPlayer]) {
        var players: [Player] = [Player(name: GKLocalPlayer.local.displayName)]
        for player in gkPlayers {
            players.append(Player(name: player.displayName))
        }
        model = .init(players)
    }
    
    func disconnect() {

        Multipeer.transceiver.stop()
        
        if Multipeer.isHost {
            selectedPeers = []
            print("selected peers: \(selectedPeers)")
            model = .init()
        }
        
        mpcStatus = ""
        hostingPeer = nil
    }
}
