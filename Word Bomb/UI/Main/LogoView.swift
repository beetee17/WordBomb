//
//  Logo.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI

struct LogoView: View {
    
    var body: some View {
        VStack(spacing: -UIScreen.main.bounds.height*0.22) {
            Image("word1")
                .resizable().scaledToFit()
                .frame(width: UIScreen.main.bounds.width*0.7, height: UIScreen.main.bounds.height*0.3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            ZStack {
                Image("bomb1")
                    .resizable().scaledToFit()
                    .frame(width: UIScreen.main.bounds.width*0.67, height: UIScreen.main.bounds.height*0.3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Image("bomb-icon")
                    .resizable().scaledToFit()
                    .frame(width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.width*0.8, alignment: .center)
                    .offset(x:-38, y:-18)
            }
        }
        .shadow(color: .black, radius: 2, x: 0, y: 4)
        .ignoresSafeArea(.all)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
