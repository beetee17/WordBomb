//
//  NewWordButton.swift
//  Word Bomb
//
//  Created by Brandon Thio on 4/8/21.
//

import SwiftUI

struct NewWordButton: View {
    @ObservedObject var dbHandler: DatabaseHandler
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { withAnimation { dbHandler.newWord() } }) {
                    HStack {
                        Image(systemName:"plus.circle.fill")
                            .foregroundColor(.green)
                        Text("Add Word")
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                
            }
            .padding(.leading)
            Divider()
        }
    }
}

struct NewWordButton_Previews: PreviewProvider {
    static var previews: some View {
        NewWordButton(dbHandler: DatabaseHandler(db: Database(context: privateContext)))
    }
}
