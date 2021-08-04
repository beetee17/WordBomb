//
//  AlphabetScrollList.swift
//  Word Bomb
//
//  Created by Brandon Thio on 4/8/21.
//

import SwiftUI

struct AlphabetScrollList: View {
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y", "z"]
    @ObservedObject var dbHandler: DatabaseHandler
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                ForEach(alphabet, id: \.self) { letter in
                    Button(letter) {
                        withAnimation {
                            dbHandler.togglePrefix(letter)
                        }
                    }
                    .textCase(.uppercase)
                    .foregroundColor(.blue)
                    .frame(width: 22, height: 22) // for drawing of background
                    .background(dbHandler.prefix == letter ? Color.gray.opacity(0.3) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
                    .frame(width: 75, height: 25) // button tappable region
                }
            }
        }
    }
}


struct AlphabetScrollList_Previews: PreviewProvider {
    static var previews: some View {
        AlphabetScrollList(dbHandler: DatabaseHandler())
    }
}
