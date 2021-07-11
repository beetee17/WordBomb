//
//  OutputText.swift
//  Word Bomb
//
//  Created by Brandon Thio on 6/7/21.
//

import SwiftUI
import AVFoundation


struct OutputText: View {
    @EnvironmentObject var viewModel: WordBombGameViewModel
    var body: some View {


        let output = viewModel.output
        let outputText = Text(output)
            .padding(.bottom, 20)
            .font(.system(size: 20, weight: .bold, design: .default))
            .textCase(.uppercase)
            .transition(AnyTransition.scale.animation(.easeInOut(duration:0.3)))
            .id(output)
            .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                                      execute: { viewModel.clearOutput(output) })
            })
    
        switch viewModel.output.contains("CORRECT") {
        case true:
            outputText
                .foregroundColor(.green)
                .onAppear(perform: { playSound(sound: "Correct", type: "wav") })
            
        case false: outputText.foregroundColor(.red)
        }
    }
    
    @State var audioPlayer: AVAudioPlayer?

    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR")
            }
        }
    }
    
}

struct OutputText_Previews: PreviewProvider {
    static var previews: some View {
        OutputText()
    }
}
