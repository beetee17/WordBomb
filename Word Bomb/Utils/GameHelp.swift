//
//  GameHelp.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/7/21.
//

import SwiftUI

struct HelpMessage: Identifiable {
    var id = UUID()
    var content: String
    var subMessages: [HelpMessage]?
    
}

struct HelpButton: View {
    
    var action: () -> Void
    var border: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: action ) {
                    Image(systemName: "questionmark.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                        
                        .frame(width: 70, height: 100, alignment:.center) // tappable area
                        .background(border ? Color.white.opacity(0.2) : Color.clear)
                    
                }
                .clipShape(Circle().scale(0.8))
            }
            Spacer()
        }
        
    }
}

struct HelpSheet: ViewModifier {
    
    @State private var showHelpSheet = false
 
    var messages = Game.helpMessages
    
    func body(content: Content) -> some View {
        ZStack {
            content
            HelpButton(action: {
                print("Show Help")
                showHelpSheet = true
            }, border: false)
            .sheet(isPresented: $showHelpSheet) {
                NavigationView {
                    List(messages, children: \.subMessages) {
                        item in
                        Text(item.content)
                            .font(item.subMessages == nil ? .system(.body, design: .rounded) : .system(.title3, design: .rounded))
                    }
                    .navigationTitle(Text("Help"))
                }
                
            }
            
        }
        .ignoresSafeArea(.all)
    }
}


extension Game {
    static let gameOverview = "Word Bomb is a multiplayer word game that allows you to test your quick-thinking and general knowledge of vocabulary or other custom categories such as countries.\n\nPlayers are tasked to form a word according to the game mode's instruction before their time runs out, which loses them a life. The last player standing is declared the winner of the game!"
    
    static let classicHelp = "In a Classic game, players are given a randomly generated syllable, and your task is to come up with a valid word that contains the syllable."
    static let exactHelp = "In an Exact game, you must come up with an answer that is found in the mode's database. For example, a database of countries would mean players are only allowed to name countries. You can create your own custom database to play with friends!"
    static let reverseHelp = "A Reverse game is similar to the Exact game, with the added constraint that the answer must start with the ending letter of the previous player's answer."
    
    static let startGameHelp = "Press to start a game! If you are not in an ongoing multiplayer game, you may start an offline, pass-and-play style game with a specified number of players and custom player names (you can change this in the settings menu). Useful if you do not have a good network connection.\n\nIf you are hosting other players via local multiplayer, start a game in the same way to play with them!"
    static let gameCenterHelp = "Clicking the Game Center button allows you to play a truly online game with others via Game Center! Simply navigate to the Host Game screen and invite your friends!\n\nCurrently does not support custom modes."
    
    static let localNetworkHelp = "You can also play a local multiplayer game with nearby players via the Local Multiplayer button."
    
    static let customModeHelp = "The Create Mode button presents a sheet where you can create your own custom modes to play with friends."
    
    static let settingHelp = "Customise various settings of the game mechanics here. Relevant settings will also apply to online gameplay if you are the host!"
    
    static let helpMessages =
        [HelpMessage(content: "Game Objective",
                     subMessages: [HelpMessage(content: gameOverview)]),
         
         HelpMessage(content: "Game Types",
                     subMessages: [
                        HelpMessage(content: "There are 3 game types currently implemented: Classic, Exact and Reverse."),
                        HelpMessage(content: "Classic", subMessages: [HelpMessage(content: classicHelp)]),
                        HelpMessage(content: "Exact", subMessages:[HelpMessage(content: exactHelp)]),
                        HelpMessage(content: "Reverse", subMessages: [HelpMessage(content: reverseHelp)])
                     ]),
         
         HelpMessage(content: "Start Game", subMessages: [HelpMessage(content: startGameHelp)]),
         
         HelpMessage(content: "Multiplayer",
                     subMessages: [
                        HelpMessage(content: "There are two ways to play an online game with your friends!"),
                        HelpMessage(content: "Game Center", subMessages: [HelpMessage(content: gameCenterHelp)]),
                        HelpMessage(content: "Local Network", subMessages: [HelpMessage(content: localNetworkHelp)])
                     ]),
         
         HelpMessage(content: "Custom Modes", subMessages: [HelpMessage(content: customModeHelp)]),
         
         HelpMessage(content: "Settings", subMessages: [HelpMessage(content: settingHelp)])
        ]
}
