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
    @State private var timeDifficulty = UserDefaults.standard.float(forKey: "Time Difficulty")
    @State private var timeConstraint = UserDefaults.standard.float(forKey: "Time Constraint")
    @State private var difficultyMultiplier = UserDefaults.standard.double(forKey: "Difficulty Multiplier")
    @State private var syllableDifficulty = UserDefaults.standard.double(forKey: "Syllable Difficulty")
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    Section(footer: Text("Changes the number of players in offline gameplay.")) {
                        Stepper("Number of Players: \(numPlayers)", value: $numPlayers, in: 2...10)
                        NavigationLink("Edit Player Names", destination: PlayerEditorView(playerNames: $playerNames, numPlayers: numPlayers))
                    }
                    
                    Section(footer: Text("Changes the number of lives each player begins with.")) {
                        
                        Stepper("Player Lives: \(playerLives)", value: $playerLives, in: 1...10)
                        
                        HStack {
                            
                            ForEach(0..<playerLives, id: \.self) { i in
                                
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                            
                        }
                    }
                    
                    
                    Section(footer: Text("Changes the initial time for each player.")) {
                        Stepper("Time Limit: \(timeLimit, specifier: "%.1f") s", value: $timeLimit, in: 1...50, step: 0.5)
                    }
                    
                    Section(footer: Text("Changes the factor applied to the time limit after each turn.")) {
                        Stepper("Time Multiplier: \(timeDifficulty, specifier: "%.2f")", value: $timeDifficulty, in: 0.5...1, step: 0.05)
                    }
                    
                    Section(footer: Text("Changes the lowest amount of time allowed for each turn.")) {
                        Stepper("Time Constraint: \(timeConstraint, specifier: "%.1f") s", value: $timeConstraint, in: 1...timeLimit, step: 0.5)
                        
                    }
                    Section(footer: Text("Changes the rate of increase in difficulty level. Only applies to Contains game mode")) {
                        Stepper("Difficulty Multiplier: \(difficultyMultiplier, specifier: "%.2f")", value: $difficultyMultiplier, in: 0...0.5, step: 0.05)
                    
                    }
                    Section(footer: Text("Determines the maximum frequency (in 100s) of syllables during end-game. Only applies to Contains game mode")) {
                        Stepper("Syllable Difficulty: \(syllableDifficulty, specifier: "%.1f")", value: $syllableDifficulty, in: 1...10, step: 0.5)
                    
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
                .frame(width: UIScreen.main.bounds.width, height: 50, alignment: .center)
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
        UserDefaults.standard.set(timeDifficulty, forKey: "Time Difficulty")
        UserDefaults.standard.set(difficultyMultiplier, forKey: "Difficulty Multiplier")
        UserDefaults.standard.set(syllableDifficulty, forKey: "Syllable Difficulty")
        isPresented = false
        viewModel.updateGameSettings()
        
    }
}

struct SettingsMenuForm_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu(isPresented: .constant(true))
    }
}
