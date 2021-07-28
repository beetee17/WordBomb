//
//  GameHelp.swift
//  Word Bomb
//
//  Created by Brandon Thio on 28/7/21.
//

import SwiftUI

struct HelpMessage: Identifiable {
    var id = UUID()
    var content: String
    var subMessages: [HelpMessage]?
    
}

struct HelpButton: View {
    
    var action: () -> Void
    var border: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: action ) {
                    Image(systemName: "questionmark.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                        
                        .frame(width: 70, height: 100, alignment:.center) // tappable area
                        .background(border ? Color.white.opacity(0.2) : Color.clear)
                    
                }
                .clipShape(Circle().scale(0.8))
            }
            Spacer()
        }
        
    }
}

struct HelpSheet: ViewModifier {
    
    @State private var showHelpSheet = false
 
    var messages = Game.helpMessages
    
    func body(content: Content) -> some View {
        ZStack{
            content
            HelpButton(action: {
                print("Show Help")
                showHelpSheet = true
            }, border: false)
            .sheet(isPresented: $showHelpSheet) {
                NavigationView {
                    List(messages, children: \.subMessages) {
                        item in
                        Text(item.content)
                    }
                    .navigationTitle(Text("Help"))
                }
                
            }
            
        }
        
        .ignoresSafeArea(.all)
    }
}

