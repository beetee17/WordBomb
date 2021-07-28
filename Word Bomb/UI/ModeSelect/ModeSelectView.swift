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
    var gameType: GameType
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    @State private var contentOverflow = false
    
    var body: some View {
        
        VStack(spacing:25) {
            
            SelectModeText()
            
            VStack(spacing: 50) {

                ForEach(Game.modes) { mode in
                    if mode.gameType == gameType {
                        ModeSelectButton(gameMode: mode)
                    }
                }
                .transition(.move(edge: .trailing))
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))

                ForEach(items) { item in
                    
                    ForEach(GameType.allCases, id: \.self) { type in
                        if item.gameType! == type.rawValue && self.gameType == type {

                            CustomModeButton(item: item)
                        }
                    }
                }
                .transition(.move(edge: .trailing))
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                .frame(width: Device.width)
                
            }
            .background(
                // hacky way to ensure geometry is always updated
                GeometryReader { contentGeometry in
                Color.clear
                .onAppear() {
                    contentOverflow = contentGeometry.size.height > Device.height/2
//                    print(contentGeometry.size.height)
                }
                .onChange(of: Date()) { _ in
                    contentOverflow = contentGeometry.size.height > Device.height/2
//                    print(contentGeometry.size.height)
                }
            })
            .useScrollView(when: contentOverflow)
            .frame(maxHeight: Device.height/2, alignment: .center)
            .frame(width: Device.width)
            
            Game.backButton {
                withAnimation { viewModel.changeViewToShow(.gameTypeSelect) }
            }
            .offset(y: 25)
        }
        .helpSheet()
        .transition(.move(edge: .trailing))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
    }
}


struct SelectModeText: View {
    
    var body: some View {
        Text("Select Mode")
            .fontWeight(.bold)
            .font(.largeTitle)
    }
}
struct ModeSelectButton: View {
    
    var gameMode: GameMode
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        
        Button("\(gameMode.modeName)") {
            // set game mode and proceed to start game
            withAnimation {
                viewModel.startGame(mode: gameMode)
                viewModel.changeViewToShow(.game)
            }
            print("\(gameMode.modeName) mode!")
        }
        .buttonStyle(MainButtonStyle())
    }
}


struct ModeSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        ModeSelectView(gameType: .Classic).environmentObject(WordBombGameViewModel())
    }
}
