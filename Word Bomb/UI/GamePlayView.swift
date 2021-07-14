//
//  GamePlayView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 14/7/21.
//

import SwiftUI

struct GamePlayView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var instructionText: some View {
        viewModel.instruction.map { Text($0)
                .boldText()
            
        }
    }
    var queryText: some View {
        viewModel.query.map { Text($0).boldText() }
    }
    
    var body: some View {
        ZStack {
            let screen = UIScreen.main.bounds
            
                  // for debugging preview
//                ZStack {
//                    Button("ANIMATE") {
//                        viewModel.animate.toggle()
//                    }
//                }
//                .padding(.top,200)
            VStack {
                
                TopBarView()
                    .offset(x: 0, y: 60)
                    .padding(.horizontal, 5)
                    .ignoresSafeArea(.all)
                
                PlayerView(numPlaying: viewModel.players.numPlaying())
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                instructionText
                InputView()
                queryText
                ZStack {
                    Text("INVISIBLE PLACEHOLDER TEXT")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .textCase(.uppercase)
                        .opacity(0)
                    OutputText()
                }
                
                Spacer()
            }
            .ignoresSafeArea(.all)
            
            
            
        }
        .blur(radius: .pauseMenu == viewModel.viewToShow ? 10 : 0, opaque: false)
    }
    
}

struct GamePlayView_Previews: PreviewProvider {
    static var previews: some View {
        GamePlayView().environmentObject(WordBombGameViewModel())
    }
}
