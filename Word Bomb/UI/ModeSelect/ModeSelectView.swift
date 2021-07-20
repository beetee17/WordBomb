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
        
        VStack {
            
            SelectModeText()
            
            VStack(spacing: 50) {
                ForEach(Defaults.gameModes) { mode in
                    if mode.gameType == gameType { ModeSelectButton(gameMode: mode) }
                }
                
                ForEach(items) {
                    item in
                    
                    ForEach(Defaults.gameTypes, id: \.0) { typeName, gameType in
                        if item.gameType! == typeName && gameType == self.gameType {
                            
                            CustomModeButton(item: item)
                        }
                    }
                }
                
                .frame(width: UIScreen.main.bounds.width)
                
            }
            .background(
                // hacky way to ensure geometry is always updated
                GeometryReader { contentGeometry in
                Color.clear
                .onAppear() {
                    contentOverflow = contentGeometry.size.height > UIScreen.main.bounds.height/2
                    print(contentGeometry.size.height)
                }
                .onChange(of: Date()) { _ in
                    contentOverflow = contentGeometry.size.height > UIScreen.main.bounds.height/2
                    print(contentGeometry.size.height)
                }
            })
            .useScrollView(when: contentOverflow)
            .frame(maxHeight: UIScreen.main.bounds.height/2, alignment: .center)
            .frame(width: UIScreen.main.bounds.width)
            
            Button(action: { withAnimation { viewModel.changeViewToShow(.gameTypeSelect) } }) {
                Image(systemName: "arrow.backward")
                    .font(Font.title.bold())
                    .foregroundColor(.white)
                
            }
            .offset(x: 0, y: 50) // offset by VStack spacing
        }
        .transition(.move(edge: .trailing))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .environmentObject(viewModel)
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
            withAnimation { viewModel.startGame(mode: gameMode) }
            print("\(gameMode.modeName) mode!")
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .buttonStyle(MainButtonStyle())
    }
}


struct ModeSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        ModeSelectView(gameType: .Exact).environmentObject(WordBombGameViewModel())
    }
}
