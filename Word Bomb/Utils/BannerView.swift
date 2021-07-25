//
//  BannerView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 24/7/21.
//

import SwiftUI

struct BannerView: View {
    let title: String
    let message: String

    var body: some View {
        ZStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.03205184274, green: 0.03314970656, blue: 0.04729758212, alpha: 1)), Color("Background")]), startPoint: .top, endPoint: .bottom)
                        
                LinearGradient(gradient: Gradient(colors: [Color("Background").opacity(0.6), Color(#colorLiteral(red: 0.07820445112, green: 0.08963582299, blue: 0.09931479403, alpha: 1)).opacity(0.3)]), startPoint: .top, endPoint: .bottom)
            
                Color.black.opacity(0.2)

            }
            .frame(width: Device.width-40, height: 100, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
            .blur(radius: 1)
            
            
            VStack(alignment: .leading, spacing:10) {
                HStack {
                    Image("icon-gradient-180")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:25, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text("Word Bomb")
                        .foregroundColor(.white.opacity(0.7))
                }
                VStack(alignment: .leading, spacing:2) {
                    Text(title)
                        .bold()
                    
                    Text(message)
                        
                }
            }
            .padding(.horizontal, 5)
            .frame(width: Device.width-40, height: 75, alignment: .leading)
        }
        .animation(.easeInOut)
        .transition(AnyTransition.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)).combined(with: .opacity))
    }
}
struct BannerViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String

    func body(content: Content) -> some View {
        ZStack {
            content
        
        VStack(spacing: 0) {
            if isPresented {
                BannerView(title: title, message: message)
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut) { self.isPresented = false }
                        }
                    }
            }
            Spacer()
        }
        }
    }
}

extension View {
    func banner(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        self.modifier(BannerViewModifier(isPresented: isPresented, title: title, message: message))
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background")
            BannerView(title: "Oops, something went wrong", message: "Please try again.")
        }
        
    }
}
