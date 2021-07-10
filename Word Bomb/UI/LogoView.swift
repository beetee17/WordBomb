//
//  Logo.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack(spacing: -160) {
            Image("Word")
                .resizable().scaledToFit()
                .frame(width: UIScreen.main.bounds.width*0.7, height: UIScreen.main.bounds.height*0.3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Image("Bomb")
                .resizable().scaledToFit()
                .frame(width: UIScreen.main.bounds.width*0.67, height: UIScreen.main.bounds.height*0.3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Spacer()
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
