//
//  CustomModeButton.swift
//  Word Bomb
//
//  Created by Brandon Thio on 10/7/21.
//

import SwiftUI

struct CustomModeButton: View {
 
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: WordBombGameViewModel
    var item: Item
    var body: some View {
        
        Button(item.name ?? "UNNAMED") {
            withAnimation{ viewModel.selectCustomMode(item) }
            
        }
        .buttonStyle(MainButtonStyle())
        .contextMenu {
            Button(action: {
                    // to avoid glitchy animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: { viewContext.delete(self.item) })
                
            })
            {
                HStack {
                    Text("Delete \"\(item.name ?? "UNAMED" )\"")
                    Image(systemName: "trash.fill")
                }
            }
        }
    }
    
}

//struct CustomModeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomModeButton()
//    }
//}
