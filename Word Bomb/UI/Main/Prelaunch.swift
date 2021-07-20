//
//  Prelaunch.swift
//  Word Bomb
//
//  Created by Brandon Thio on 20/7/21.
//

import SwiftUI
import MultipeerKit

struct Prelaunch: View {
    @State var animatingLogo = false
    @State var showMainView = false
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @EnvironmentObject var mpcDataSource: MultipeerDataSource
    @Namespace var logo
    
    var persistenceController = PersistenceController.shared
    
    var body: some View {
        Group {
            switch showMainView {
            case true:
        
                ContentView()
                    .animation(nil)
                    .environmentObject(viewModel)
                    .environmentObject(mpcDataSource)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            case false:
                ZStack {
                    Color("Background")
                        .edgesIgnoringSafeArea(.all)
                    if animatingLogo {
                        VStack {
                            LogoView()
                                .matchedGeometryEffect(id: "logo", in: logo, isSource: false)
                                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                            
                            Spacer()
                        }
                    }
                    else {
                        LogoView()
                            
                            .matchedGeometryEffect(id: "logo", in: logo, isSource: true)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                    }
                }
                
            }
        }
        .onAppear() {
            withAnimation {
                animatingLogo = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {

                showMainView = true
                
            }
        }
    }
}

struct Prelaunch_Previews: PreviewProvider {
    static var previews: some View {
        Prelaunch()
    }
}
