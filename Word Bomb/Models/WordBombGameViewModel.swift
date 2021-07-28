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
    
    init(_ viewToShow: ViewToShow = .main) {
        self.viewToShow = viewToShow
        
    }
    
    func setSharedModel(_ model: WordBombGame) {
        self.model = model
        self.model.currentPlayer = self.model.playerQueue[0]
    }
    func updatePlayerLives(_ updatedPlayers: [String:Int]) {
        model.updatePlayerLives(updatedPlayers)
    }
    func updateGameSettings() {
        model = WordBombGame()
        if selectedPeers.count > 0 {
            setOnlinePlayers(selectedPeers)
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
            Multipeer.transceiver.send(GameData(state: .paused), to: selectedPeers)
        }
        changeViewToShow(.pauseMenu)
        Game.stopTimer()
    }
    
    func resumeGame() {
        changeViewToShow(.game)
        if .gameOver != gameState {
            if Multipeer.isHost {
                Multipeer.transceiver.send(GameData(state: .playing), to: selectedPeers)
            }
            startTimer()
        }
    }
    
    func restartGame() {
        
        if gameModel != nil {
            
            gameModel!.reset()
            let instruction = model.instruction
            
            if Multipeer.isHost {
                setOnlinePlayers(selectedPeers)
            }
            
            model.handleGameState(.initial,
                                  data: ["query" : gameModel!.getRandQuery(input),
                                         "instruction" : instruction as Any])
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
        
        if item.gameType! == GameType.Exact.rawValue {
            
            startGame(mode: GameMode(modeName: item.name!, dataFile: nil, queryFile: nil, instruction: item.instruction ?? nil, words: words, queries: nil, gameType: .Exact))
        }
        
        else if item.gameType! == GameType.Classic.rawValue {
            
            let queries = decodeJSONStringtoArray(item.queries!)
            startGame(mode: GameMode(modeName: item.name!, dataFile: nil, queryFile: nil, instruction: item.instruction ?? nil, words: words, queries: queries, gameType: .Classic))
        }
        
    }
    
    func startGame(mode: GameMode) {
        
        // process the gameMode by initing the appropriate WordGameModel
        
        if mode.dataFile != nil {
            let (words, wordSets) = loadWordSets(mode)
            switch mode.gameType {
            case .Exact: gameModel = ExactWordGameModel(words: words, dataDict: wordSets)
                
            case .Classic:
                let queries = loadSyllables(mode)
                gameModel = ContainsWordGameModel(words: words, queries: queries)
                
            case .Reverse:
                gameModel = ReverseWordGameModel(words: words, dataDict: wordSets)
            }
        }
        else {
            // Loading custom mode
            switch mode.gameType {
            case .Exact: gameModel = ExactWordGameModel(words: mode.words!, dataDict: [:])
                
            case .Classic:
                break
            //                gameModel = ContainsWordGameModel(data: mode.words!, queries: mode.queries!)
            case .Reverse:
                gameModel = ReverseWordGameModel(words: mode.words!, dataDict: [:])
            }
            print("CUSTOM GAME! \(String(describing: gameModel))")
        }
        
        
        print("host is \(String(describing: hostingPeer))")
        print("selected peers \(selectedPeers)")
        
        if !(Multipeer.isNonHost || GameCenter.isNonHost) {
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
            
            if (Multipeer.isHost && isMyTurn) || (GameCenter.isHost && isMyGKTurn) {
                // turn for device hosting multiplayer game
                
                let response = gameModel!.process(input, model.query)
                    
                model.handleGameState(.playerInput, data: ["input" : input, "response" : response])
            }
            
            else if (Multipeer.isNonHost && isMyTurn)  || (!GameCenter.isHost && isMyGKTurn) {
                // turn for device not hosting but in multiplayer game
                Multiplayer.send(GameData(input: input), toHost: true)
               
                print("SENT \(input)")
                
            }

            else if Multipeer.isOffline && GameCenter.isOffline{
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
                
                if Multipeer.isHost || GameCenter.isHost {
                    let roundedValue = Int(round(model.timeLeft * 10))
                    
                    if roundedValue % 5 == 0 && model.timeLeft > 0.4 {
                        
                        if Multipeer.isHost || GameCenter.isHost {
                            Multiplayer.send(GameData(timeLeft: timeLeft), toHost: false)
                            
                        }
                        
                    }
                    if roundedValue % 10 == 0 && model.timeLeft > 0.1 {
                        let playerLives = Dictionary(model.playerQueue.map { ($0.name, $0.livesLeft) }) { first, _ in first }
                        if Multipeer.isHost || GameCenter.isHost {
                            Multiplayer.send(GameData(playerLives: playerLives), toHost: false)
                            
                        }
                        
                    }
                }
            }
            
            if model.timeLeft <= 0 && !(Multipeer.isNonHost || GameCenter.isNonHost) {
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

// MARK: - MULTIPLAYER
extension WordBombGameViewModel {
    
    var isMyGKTurn: Bool { GKLocalPlayer.local.displayName == model.currentPlayer.name }
    var isMyTurn: Bool { UserDefaults.standard.string(forKey: "Display Name")! == model.currentPlayer.name }
    
    var selectedPeers: [Peer] {
        get { Multipeer.selectedPeers }
        set {
            Multipeer.selectedPeers = newValue
            mpcStatus = newValue.count == 0 ? "" : "Hosting: \(newValue.count) Player(s)"
        }
    }
    var hostingPeer: Peer? {
        get { Multipeer.hostingPeer }
        set {
            let oldValue = Multipeer.hostingPeer
            Multipeer.hostingPeer = newValue
            
            if newValue != nil && selectedPeers.count == 0 { mpcStatus = "Connected to Host: \(newValue!.name)" }
            else if oldValue != nil && newValue == nil && selectedPeers.count == 0 { mpcStatus = "Lost Connection to Host"}
        }
    }
    
    func resetGameModel() {
        // called when a multiplayer game has ended either due to lack of players, lost of connection or game just ended
        model = .init()
        Game.stopTimer()
    }
    
    func handleDisconnected(from playerName: String) {
        for i in playerQueue.indices {
            guard i < playerQueue.count else { return }
            // if multiple disconnects at the same time -> this function may be called simultaneously
            if playerName == playerQueue[i].name {
                model.remove(playerQueue[i])
            }
            // function does not do anything if player is not in queue (e.g. the player lost just before disconnecting)
        }
    }
    func processNonHostInput(_ input: String) {
        
        print("processing \(input)")
        let response = gameModel!.process(input.lowercased().trim(), model.query)
        
        model.handleGameState(.playerInput, data: ["input" : input, "response" : response])
        
    }
    
    func setOnlinePlayers(_ players: [Any])  {
        switch players {
        case let (peers as [Peer]) as Any:
            var players: [Player] = [Player(name: UserDefaults.standard.string(forKey: "Display Name")!)]
            
            for peer in peers {
                players.enqueue(Player(name: peer.name))
            }
            
            model = .init(players)
            print("online peers \(model.playerQueue)")
            print("current player \(model.currentPlayer)")
            
        case let (gkPlayers as [GKPlayer]) as Any:
            var players: [Player] = [Player(name: GKLocalPlayer.local.displayName)]
            
            for player in gkPlayers {
                players.append(Player(name: player.displayName))
            }
            model = .init(players)
            print("gkplayers \(model.playerQueue)")
            print("current player \(model.currentPlayer)")
            setGKPlayerImages(gkPlayers)
            
        default:
            fatalError("Not a valid array of players")
        }
        
        
    }
}

// MARK: - GAME CENTER
extension WordBombGameViewModel {
    func setGKPlayerImages(_ gkPlayers: [GKPlayer]) {
        for player in model.playerQueue {
            if player.name == GKLocalPlayer.local.displayName {
                GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.normal) { image, error in
                    print("got image \(image ?? nil) for player \(player.name) with error \(String(describing: error))")
                    player.setImage(image)
                }
            }
            else {
                for gkPlayer in gkPlayers {
                    if player.name == gkPlayer.displayName {
                        gkPlayer.loadPhoto(for: GKPlayer.PhotoSize.normal) { image, error in
                            print("got image \(image ?? nil) for player \(player.name) with error \(String(describing: error))")
                            player.setImage(image)
                        }
                    }
                }
            }
        }
    }
}
// MARK: - Multipeer
extension WordBombGameViewModel {
    
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
                resetGameModel()
            case false:
                // some players disconnected
                handleDisconnected(from: peer.name)
            }
            print("selected peers \(selectedPeers)")
            
        }
        else {
            // either the disconnected peer was not in the game -> ignore
            // or as non-host, one of the participants disconnected
            handleDisconnected(from: peer.name) // this function does nothing if name is not found in the playerQueue
        }
        if peer == hostingPeer {
            
            // reset hostPeer to nil and update status
            hostingPeer = nil
            resetGameModel()
            
        }
        
        
    }
    
    func toggle(_ peer: Peer) {
        
        // first remove any unavailable peers from selected peers
        for p in selectedPeers {
            if Multipeer.transceiver.availablePeers.find(p) == nil, let index = selectedPeers.firstIndex(of: p){
                // peer is unavailable
                selectedPeers.remove(at: index)
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
            setOnlinePlayers(selectedPeers)
        case false:
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
        
        Multipeer.transceiver.receive(GameData.self) { data, sender in
            
            data.process()
        }

        // participant successfully connected to peer and received data from host
        Multipeer.transceiver.receive(Bool.self) { payload, sender in
            print("Got boolean from host \(sender.name)! \(payload)")
            switch payload {
            case true: // host selected this peer to join game
                self.hostingPeer = sender
                
            case false: // host deselected this peer
                self.hostingPeer = nil
            }
            
        }
        
        // send model at .initial game state to signify start of game by host
        // every 0.5s -> update time to keep in sync
        // on input -> send new query and output

        
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
    
   
}
