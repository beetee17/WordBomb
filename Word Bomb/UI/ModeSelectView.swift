//
//  ModeSelectView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI


struct ModeSelectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        ZStack {
            Color.clear
            SelectModeText()
                
            VStack(spacing: 50) {
                ForEach(Defaults.gameModes) { mode in
                    if mode.gameType == viewModel.gameType { ModeSelectButton(gameMode: mode) }
                }
                
                ForEach(items) {
                    item in
                    
                    ForEach(Defaults.gameTypes, id: \.0) { typeName, gameType in
                        if item.gameType! == typeName && gameType == viewModel.gameType {
                            
                            CustomModeButton(item: item)
                        }
                    }
                }
                
                Button("BACK") {
                    print("BACK")
                    withAnimation { viewModel.changeViewToShow(.gameTypeSelect) }
                }
                .buttonStyle(MainButtonStyle())
                
            }
        }
        .transition(.move(edge: .trailing))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .environmentObject(viewModel)
    }
}


struct SelectModeText: View {
    
    var body: some View {
        VStack {
            Text("Select Mode")
                .fontWeight(.bold)
                .font(.largeTitle)
            Spacer()
        }
        .padding(.top, 100)
    }
}
struct ModeSelectButton: View {
    
    var gameMode: GameMode
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        Button("\(gameMode.modeName)") {
            // set game mode and proceed to start game
            withAnimation { viewModel.selectMode(gameMode) }
            print("\(gameMode.modeName) mode!")
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .buttonStyle(MainButtonStyle())
    }
}


struct ModeSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        ModeSelectView()
    }
}
