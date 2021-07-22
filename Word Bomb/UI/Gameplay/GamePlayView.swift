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
        viewModel.query.map { Text($0)
            .boldText()
        }
    }
    
    var body: some View {
        ZStack {
            
                  // for debugging preview
//                ZStack {
//                    Button("ANIMATE") {
//                        viewModel.animate.toggle()
//                    }
//                }
//                .padding(.top,200)
            ZStack {
                Color.clear
                
                VStack {
                    TopBarView()
                        .padding(.horizontal, 5)
                        .ignoresSafeArea(.all)

                    Spacer()
                    
                }
                
                VStack {
                    PlayerView()
                        .offset(x: 0, y: Device.height*0.1)
                    Spacer()
                }

            }
            .ignoresSafeArea(.all)
            
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
