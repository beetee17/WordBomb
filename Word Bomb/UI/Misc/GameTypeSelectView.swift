//
//  GameTypeSelect.swift
//  Word Bomb
//
//  Created by Brandon Thio on 10/7/21.
//

import SwiftUI


struct GameTypeSelectView: View {

    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var body: some View {
        ZStack {
            Color.clear
            SelectGameTypeText()
                
            VStack(spacing: 50) {
                ForEach(Defaults.gameTypes, id: \.0) { typeName, gameType in
                    Button(typeName) {

                        viewModel.gameType = gameType
                        withAnimation { viewModel.changeViewToShow(.modeSelect) }
                        
                    }.buttonStyle(MainButtonStyle())
                    
                }

                Button("BACK") {
                    print("BACK")
                    withAnimation { viewModel.changeViewToShow(.main) }
                }
                .buttonStyle(MainButtonStyle())
            }
        }
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
        .environmentObject(viewModel)
    }
}


struct SelectGameTypeText: View {
    
    var body: some View {
        VStack {
            Text("Select Game Type")
                .fontWeight(.bold)
                .font(.largeTitle)
            Spacer()
        }
        .padding(.top, 100)
    }
}

//
//
//struct ModeSelectView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ModeSelectView()
//    }
//}
