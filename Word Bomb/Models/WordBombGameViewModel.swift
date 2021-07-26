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
    
    @Published var showPreLaunchAnimation = true
    @Published var animateLogo = false
    @Published private var model: WordBombGame = WordBombGame()
    @Published private var gameModel: WordGameModel? = nil
    @Published var viewToShow: ViewToShow = .main
    
    @Published var input = ""
    @Published var forceHideKeyboard = false
    @Published var gameType: GameType? = nil
    
    @Published var mpcStatus = ""
    @Published var debugging = false
    @Published var playersReady = 0
    
    
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
        GKMatchManager.shared.cancel()
        playersReady = 0
        GameCenter.hostPlayerName = nil
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
            if !GameCenter.isHost {
                changeViewToShow(.game)
            }
            
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
                if !debugging {
                    model.timeLeft = max(0, model.timeLeft - 0.1)
                }
                
                if Multipeer.isHost {
                    let roundedValue = Int(round(model.timeLeft * 10))
                    if roundedValue % 5 == 0 && model.timeLeft > 0.4 {
                        Multipeer.transceiver.send(["Updated Time Left" : model.timeLeft], to: selectedPeers)
                    }
                }
                
                if GameCenter.isHost {
                    let roundedValue = Int(round(model.timeLeft * 10))
                    if roundedValue % 5 == 0 && model.timeLeft > 0.4 {
                        GameCenter.sendDictionary(["Updated Time Left" : String(model.timeLeft)], toHost: false)
                    }
                    if roundedValue % 10 == 0 && model.timeLeft > 0.1 {
                        
                        GameCenter.sendPlayerLives(model.playerQueue)
                    }
                    
                }
            }
            
            if model.timeLeft <= 0 && (Multipeer.isHost || GameCenter.isHost || (GameCenter.isOffline && Multipeer.isOffline)) {
                // only handle time out in offline play or if host of online match
                
                DispatchQueue.main.async {
                    self.model.handleGameState(.playerTimedOut)
                }
            }
        }
    }
    
    func handleGameState(_ gameState: GameState, data: [String : Any]? = [:]) {
        model.handleGameState(gameState, data: data)
    }
    
    // check if output is still the same as current to avoid clearing of new outputs
    func clearOutput(_ output: String) { if output == model.output { model.clearOutput() } }

    // to allow contentView to read model's value and update
    var playerQueue: [Player] { model.playerQueue }
    
    var currentPlayer: Player { model.currentPlayer }
    
    var livesLeft: Int { model.livesLeft }
    
    var instruction: String? { model.instruction }
    
    var query: String? {
        get { model.query }
        set { model.query = newValue }
    }
    
    var timeLimit: Float {
        get { model.timeLimit }
        set { model.timeLimit = newValue }
    }
    
    var timeLeft: Float {
        get { model.timeLeft }
        set { model.timeLeft = newValue }
    }
    
    var output: String { model.output }
    
    var gameState: GameState { model.gameState }
    
    var animateExplosion: Bool {
        
        get { model.animateExplosion }
        set { model.animateExplosion =  newValue }
    }
    
   
}

// MARK: - GAME CENTER
extension WordBombGameViewModel {
    
    var isMyGKTurn: Bool { GKLocalPlayer.local.displayName == model.currentPlayer.name }
    
    func setGameModel(_ model: WordBombGame) {
        self.model = model
        self.model.currentPlayer = self.model.playerQueue[0]
    }
    
    func handleDisconnected(_ player: GKPlayer) {
        for i in playerQueue.indices {
            if player.displayName == playerQueue[i].name {
                model.remove(playerQueue[i])
            }
            // function does not do anything if player is not in queue (e.g. the player lost just before disconnecting)
        }
    }
    func setGKPlayers(_ gkPlayers: [GKPlayer]) {

        var players: [Player] = [Player(name: GKLocalPlayer.local.displayName)]
        
        for player in gkPlayers {
            players.append(Player(name: player.displayName))
        }
        self.model = .init(players)
        print("gkplayers \(self.model.playerQueue)")
        print("current player \(self.model.currentPlayer)")
        setGKPlayerImages(gkPlayers)
        
    }
    
    func setGKPlayerImages(_ gkPlayers: [GKPlayer]) {
        for player in model.playerQueue {
            if player.name == GKLocalPlayer.local.displayName {
                GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.normal) { image, error in
                    print("got image \(image) for player \(player.name) with error \(error)")
                    player.setImage(image)
                }
            }
            else {
                for gkPlayer in gkPlayers {
                    if player.name == gkPlayer.displayName {
                        gkPlayer.loadPhoto(for: GKPlayer.PhotoSize.normal) { image, error in
                            print("got image \(image) for player \(player.name) with error \(error)")
                            player.setImage(image)
                        }
                    }
                }
            }
        }
    }
    
    func updatePlayerLives(_ updatedPlayers: String) {
        model.updatePlayerLives(updatedPlayers)
    }
    
    func processGKInput() {

        input = input.lowercased().trim()
        print("processing input \(input)")
        // check additonl condition that current player is still the player that sent the input
        if !(input == "" || model.timeLeft <= 0) {
            
            if GameCenter.isHost && isMyGKTurn {
                // turn for device hosting multiplayer game
                print("Am host and my turn")
                let response = gameModel!.process(input, model.query)
                model.handleGameState(.playerInput, data: ["input" : input, "response" : response])
                
            }
            
            else if !GameCenter.isHost && isMyGKTurn  {
                print("Not host and my turn")
                // turn for device not hosting but in multiplayer game
                GameCenter.sendDictionary(["nonHostInput" : input], toHost: true)
               
            }
            else {
                print("Host: \(GameCenter.hostPlayerName), Am Host: \(GameCenter.isHost)")
                print("My turn: \(isMyGKTurn)")
            }
            
        }
        
    }
    
}


// MARK: - Multipeer

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
    
            switch selectedPeers.count == 0 {
            case true:
                // all players disconnected
                mpcStatus = ""
                resetGameModel()
            case false:
                // some players disconnected
                mpcStatus = "Hosting: \(selectedPeers.count) Player(s)"
                setOnlinePlayers()
            }
            print("selected peers \(selectedPeers)")
            
        }
        else { print("did not find peer") }
        
       
        
        if peer == hostingPeer {
            
            // reset hostPeer to nil and update status
            hostingPeer = nil
            mpcStatus = "Lost Connection to Host: \(peer.name)"
            resetGameModel()
            
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
            resetGameModel()
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
    
    func disconnect() {

        Multipeer.transceiver.stop()
        
        if Multipeer.isHost {
            selectedPeers = []
            print("selected peers: \(selectedPeers)")
            resetGameModel()
        }
        
        mpcStatus = ""
        hostingPeer = nil
    }
    
    func resetGameModel() {
        // called when a multiplayer game has ended either due to lack of players, lost of connection or game just ended
        model = .init()
        Game.stopTimer()
    }
}
