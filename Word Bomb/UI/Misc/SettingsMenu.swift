//
//  SettingsMenuView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 11/7/21.
//

import SwiftUI


struct SettingsMenu: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    @State private var numPlayers = UserDefaults.standard.integer(forKey: "Num Players")
    @State var playerNames = UserDefaults.standard.stringArray(forKey: "Player Names")!
    @State private var playerLives = UserDefaults.standard.integer(forKey: "Player Lives")
    @State private var timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
    @State private var timeMultipier = UserDefaults.standard.float(forKey: "Time Multiplier")
    @State private var timeConstraint = UserDefaults.standard.float(forKey: "Time Constraint")

    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    Section(footer: Text("Number of players in offline gameplay.")) {
                        Stepper("Number of Players: \(numPlayers)", value: $numPlayers, in: 2...10)
                        NavigationLink("Edit Player Names", destination: PlayerEditorView(playerNames: $playerNames, numPlayers: numPlayers))
                    }
                    
                    Section(footer: Text("Number of lives each player starts with.")) {
                        
                        Stepper("Player Lives: \(playerLives)", value: $playerLives, in: 1...10)
                        
                        HStack {
                            
                            ForEach(0..<playerLives, id: \.self) { i in
                                
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                            
                        }
                    }
                    
                    
                    Section(footer: Text("Initial time given to each player.")) {
                        Stepper("Time Limit: \(timeLimit, specifier: "%.1f") s", value: $timeLimit, in: 1...50, step: 0.5)
                    }
                    
                    Section(footer: Text("Factor applied to the time limit after each round.")) {
                        Stepper("Time Multiplier: \(timeMultipier, specifier: "%.2f")", value: $timeMultipier, in: 0.7...1, step: 0.01)
                    }
                    
                    Section(footer: Text("Minimum amount of time allowed for each turn.")) {
                        Stepper("Time Constraint: \(timeConstraint, specifier: "%.1f") s", value: $timeConstraint, in: 1...timeLimit, step: 0.5)
                        
                    }
                    
                    
                }
                .navigationBarTitle(Text("Settings"))
                
                
                Button(action: { saveSettings() }) {
                    HStack {
                        Spacer()
                        Text("Save Changes")
                            .font(Font.system(size: 24))
                        Spacer()
                    }
                }
                .frame(width: Device.width, height: 50, alignment: .center)
                .contentShape(Rectangle())
                
            }
            
            
        }
        .onChange(of: timeLimit, perform: {_ in timeConstraint = min(timeLimit, timeConstraint) })
        
        
    }

    
    
    
    private func saveSettings() {
        
        UserDefaults.standard.set(numPlayers, forKey: "Num Players")
        UserDefaults.standard.set(playerNames, forKey: "Player Names")
        UserDefaults.standard.set(playerLives, forKey: "Player Lives")
        UserDefaults.standard.set(timeLimit, forKey: "Time Limit")
        UserDefaults.standard.set(timeConstraint, forKey: "Time Constraint")
        UserDefaults.standard.set(timeMultipier, forKey: "Time Multiplier")

        isPresented = false
        viewModel.updateGameSettings()
        
    }
}

struct SettingsMenuForm_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu(isPresented: .constant(true))
    }
}
