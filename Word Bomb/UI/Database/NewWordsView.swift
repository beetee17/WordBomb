//
//  NewWordsView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 4/8/21.
//

import SwiftUI

struct NewWordsView: View {
    @ObservedObject var dbHandler: DatabaseHandler
    
    var body: some View {
        ForEach(dbHandler.wordsToAdd) { word in
            VStack {
                TextField("Enter Word",
                          text: Binding(
                            get: {word.content},
                            set: {word.content = $0}),
                          onCommit: {
                            withAnimation{
                                dbHandler.saveNewWord(word)
                            }
                          })
                            
                    .padding(.leading)
                Divider()
            }
        }
    }
}

struct NewWordsView_Previews: PreviewProvider {
    static var previews: some View {
        NewWordsView(dbHandler: DatabaseHandler(db: Database(context: privateContext)))
    }
}
