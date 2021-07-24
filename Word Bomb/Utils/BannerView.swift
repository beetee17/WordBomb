//
//  BannerView.swift
//  Word Bomb
//
//  Created by Brandon Thio on 24/7/21.
//

import SwiftUI


struct BannerData {
    let title: String
    var actionTitle: String? = nil
    // Level to drive tint colors and importance of the banner.
    var level: Level = .success

    enum Level {
        case warning
        case success

        var tintColor: Color {
            switch self {
            case .warning: return .yellow
            case .success: return .green
            }
        }
    }
}
struct BannerView: View {
    let data: BannerData
    var action: (() -> Void)

    var body: some View {
        
        HStack {
            Text(data.title)
            Spacer()
//            Button(action:
//                    action, label: {
//                Text(data.actionTitle ?? "Action")
//                    .foregroundColor(.white)
//                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
//                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).foregroundColor(Color.black.opacity(0.3)))
//            })
            
        }
        .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8))
        .background(data.level.tintColor)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
    }
}
struct BannerViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let data: BannerData
    let action: (() -> Void)

    func body(content: Content) -> some View {
        ZStack {
            content
        
        VStack(spacing: 0) {
            if isPresented {
                BannerView(data: data, action: action)
                    .animation(.easeInOut)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isPresented = false
                        }
                    }
            }
            Spacer()
        }
        }
    }
}

extension View {
    func banner(isPresented: Binding<Bool>, data: BannerData, action: @escaping (() -> Void)) -> some View {
        self.modifier(BannerViewModifier(isPresented: isPresented, data: data, action: action))
    }
}

//struct BannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerView()
//    }
//}
