//
//  MainView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 3/7/21.
//

import SwiftUI
import GameKit
import GameKitUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: WordBombGameViewModel
    @State var creatingMode = false
    @State var changingSettings = false
    @State var showMultiplayerOptions = false
    @State var searchingDatabase = false
    
    @Namespace var mainView
    @State var isFirstLaunch = UserDefaults.standard.bool(forKey: "First Launch")
    
    var body: some View {
        
        ZStack {
            
            Color.clear
            
            VStack(spacing:1) {
                if viewModel.animateLogo {
                    LogoView()
                        .matchedGeometryEffect(id: "logo", in: mainView, isSource: false)
                }
                
                VStack(spacing: 30) {
                    
                    Game.mainButton(label: "START GAME", systemImageName: "gamecontroller") {
                        withAnimation { viewModel.changeViewToShow(.gameTypeSelect) }
                    }
                    
                    
                    Game.mainButton(label: "MULTIPLAYER", systemImageName: "person.3") {
                        withAnimation {
                            showMultiplayerOptions.toggle()
                        }
                    }
                    
                    if showMultiplayerOptions {
                        
                        VStack(spacing:10) {
                            Game.mainButton(label: "GAME CENTER",
                                            image: AnyView(Image("GK Icon")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(height: 20))) {
                                withAnimation {
                                    
                                    // bug where tapping the button does not immediately dismiss the main view?
                                    if viewModel.viewToShow == .main {
                                        print("selected game center")
                                        showMultiplayerOptions = false
                                        viewModel.changeViewToShow(.GKMain)
                                    }
                                }
                            }
                            Game.mainButton(label: "LOCAL NETWORK", systemImageName: "wifi") {
                                withAnimation {
                                    if viewModel.viewToShow == .main {
                                        print("selected local network")
                                        showMultiplayerOptions = false
                                        viewModel.changeViewToShow(.multipeer)
                                    }
                                }
                            }
                        }
                        
                    }
                    Game.mainButton(label: "CREATE MODE", systemImageName: "plus.circle") {
                        withAnimation { creatingMode = true }
                    }
                    .sheet(isPresented: $creatingMode, onDismiss: {}) { CustomModeForm() }
                    
                    Game.mainButton(label: "DATABASE", systemImageName: "magnifyingglass.circle") {
                        searchingDatabase = true
                    }
                    .sheet(isPresented: $searchingDatabase) {
                        DatabaseListView()
                    }
                    
                    Game.mainButton(label: "SETTINGS", systemImageName: "gearshape") {
                        withAnimation { changingSettings = true }
                    }
                    .sheet(isPresented: $changingSettings) { SettingsMenu(isPresented: $changingSettings).environmentObject(viewModel) }
                    
                }
                .opacity(viewModel.showPreLaunchAnimation ? 0 : 1)
            }
            .padding(.bottom, 20)
            .blur(radius: isFirstLaunch && !viewModel.showPreLaunchAnimation ? 2 : 0)
            
            
            
            if !viewModel.animateLogo && viewModel.showPreLaunchAnimation {
                LogoView()
                    
                    .matchedGeometryEffect(id: "logo", in: mainView, isSource: true)
                    .frame(width: Device.width, height: Device.height, alignment: .center)
            }
            
            if isFirstLaunch && !viewModel.showPreLaunchAnimation {
                FirstLaunchInstructionsView()
                    .onTapGesture {
                        UserDefaults.standard.setValue(false, forKey: "First Launch")
                        print("set first launch to: \(UserDefaults.standard.bool(forKey: "First Launch"))")
                        isFirstLaunch = false
                    }
            }
            
        }
        .helpSheet()
        .onAppear() {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 1)) {
                viewModel.animateLogo = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                
                withAnimation(.easeInOut) { viewModel.showPreLaunchAnimation = false }
            }
        }
        .transition(.asymmetric(insertion: AnyTransition.move(edge: .leading), removal: AnyTransition.move(edge: .trailing)))
        .animation(Game.mainAnimation)
        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/) // transition does not work with zIndex set to 0
        
    }
}


struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = WordBombGameViewModel(.main)
        ZStack {
            Color("Background").ignoresSafeArea()
            
            let mainView = MainView()
            mainView
            //            Button(action: {
            //                mainView.isFirstLaunch = true
            //                game.showPreLaunchAnimation = false
            //            }) {
            //                Text("Toggle intro screen")
            //            }
            //            .offset(y: 350)
        }
        .environmentObject(game)
    }
}
