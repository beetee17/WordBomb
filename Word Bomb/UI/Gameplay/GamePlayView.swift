//
//  GamePlayView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 14/7/21.
//

import SwiftUI
import GameKit
import GameKitUI

struct GamePlayView: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    
    var match: GKMatch? 
    
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
                    switch self.match == nil {
                    case true:
                        TopBarView()
                            .padding(.horizontal, 5)
                            .ignoresSafeArea(.all)
                        
                    case false:
                        HStack() {
                            GKQuitButton()
                            Spacer()
                            TimerView()
                            Spacer()
                            Text("Hi").opacity(0)
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, viewModel.playerQueue.count > 2 ? 10 : 50)
                    }
                    Spacer()
                }
                
                VStack {
                    PlayerView()
                        .offset(x: 0, y: Device.height*0.15)
                    Spacer()
                }
                
            }
            .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                instructionText
                queryText
                switch self.match == nil {
                case true:
                    InputView()
                    
                case false:
                    TextField("INPUT",
                              text: $viewModel.input,
                              onCommit: {
                                viewModel.processGKInput()
                                viewModel.input = ""
                              })
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                        .multilineTextAlignment(.center)
                    
                }
                
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
        GamePlayView(match: GKMatch()).environmentObject(WordBombGameViewModel())
    }
}
