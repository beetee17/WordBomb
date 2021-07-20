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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7,
                                              execute: {
                    do {
                        viewContext.delete(self.item)
                        try viewContext.save()
                    }
                    catch let error {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    
                })
                
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
