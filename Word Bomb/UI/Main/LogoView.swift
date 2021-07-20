//
//  Logo.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI

struct LogoView: View {
    
    var body: some View {
        
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 794/2, height: 511/2)
            .shadow(color: .black, radius: 2, x: 0, y: 4)
            .ignoresSafeArea(.all)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
