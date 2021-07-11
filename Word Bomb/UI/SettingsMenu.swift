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
    @State private var timeLimit = UserDefaults.standard.float(forKey: "Time Limit")
    @State private var timeDifficulty = UserDefaults.standard.float(forKey: "Time Difficulty")
    @State private var timeConstraint = UserDefaults.standard.float(forKey: "Time Constraint")
    
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    Section(footer: Text("Changes the number of players in offline gameplay.")) {
                        Stepper("Number of Players: \(numPlayers)", value: $numPlayers, in: 1...20)
                        NavigationLink("Edit Player Names", destination: PlayerEditorView())
                    }
                    
                    Section(footer: Text("Changes the initial time for each player.")) {
                        Stepper("Time Limit: \(timeLimit, specifier: "%.1f")", value: $timeLimit, in: 3...100, step: 0.5)
                    }
                    
                    Section(footer: Text("Changes the factor applied to the time limit after each turn.")) {
                        Stepper("Time Multiplier: \(timeDifficulty, specifier: "%.1f")", value: $timeDifficulty, in: 0.5...1, step:0.1)
                    }
                    
                    Section(footer: Text("Changes the lowest amount of time allowed for each turn.")) {
                        Stepper("Time Constraint: \(timeConstraint, specifier: "%.1f")", value: $timeConstraint, in: 1...timeLimit, step:0.5)
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
        
        
    }
    private func saveSettings() {
        
        UserDefaults.standard.set(numPlayers, forKey: "Num Players")
        UserDefaults.standard.set(timeLimit, forKey: "Time Limit")
        UserDefaults.standard.set(timeConstraint, forKey: "Time Constraint")
        UserDefaults.standard.set(timeDifficulty, forKey: "Time Difficulty")
        isPresented = false
        viewModel.updateGameSettings()
    }
}

struct SettingsMenuForm_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu(isPresented: .constant(true))
    }
}
