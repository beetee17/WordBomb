//
//  WordSearchBar.swift
//  Word Bomb
//
//  Created by Brandon Thio on 4/8/21.
//

import SwiftUI

struct WordSearchBar: View {
    @ObservedObject var dbHandler: DatabaseHandler
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search", text: $dbHandler.filter)
                .foregroundColor(.primary)
            
            if dbHandler.isLoading {
                ProgressView()
            }
            Button(action: {
                dbHandler.filter = ""
                
            }) {
                Image(systemName: "xmark.circle.fill").opacity(dbHandler.filter == "" ? 0 : 1)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
    }
}

struct WordSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchBar(dbHandler: DatabaseHandler())
    }
}
