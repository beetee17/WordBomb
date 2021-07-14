//
//  Styles.swift
//  Word Bomb
//
//  Created by Brandon Thio on 2/7/21.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    let width = UIScreen.main.bounds.width/2
    let height = UIScreen.main.bounds.height*0.07
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textCase(.uppercase)
            .font(Font.title2.bold())
            .frame(width: width, height: height)
            .padding(.horizontal)
            .lineLimit(1).minimumScaleFactor(0.5)
            .foregroundColor(Color.white)
            .background(Color(red: 229/255, green: 142/255, blue:38/255, opacity: 1))
//            .background(RadialGradient(colors: [.orange, .gray], center: .center, startRadius: 0 , endRadius: 400))
//            .shadow(color: .black, radius: 2, x: 0, y: 3)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .contentShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            
            
    }
}

extension Text {
    func boldText() -> some View {
        self
            .font(.title)
            .fontWeight(.bold)
            .textCase(.uppercase)
    }
}


// Permanent Keyboard
// https://stackoverflow.com/questions/65545374/how-to-always-show-the-keyboard-in-swiftui

struct PermanentKeyboard: UIViewRepresentable {
    @Binding var text: String
    var forceResignFirstResponder = false
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PermanentKeyboard
        
        init(_ parent: PermanentKeyboard) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            //Async to prevent updating state during view update
            DispatchQueue.main.async {

                if string != "" {
                    self.parent.text.append(string)
                        
                    }
                    
                //Allows backspace
                else {
                    self.parent.text.removeLast()
                }
            }
            
            return false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.delegate = context.coordinator
        
        // settings
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .words
        textfield.font = UIFont.systemFont(ofSize: 20)
        
        //Makes textfield invisible
        textfield.textColor = .clear

        return textfield
    }
    
    mutating func forceHideKeyboard() {
        forceResignFirstResponder = true
        print(forceResignFirstResponder)
 
    }
    
    
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text

        //Makes keyboard permanent
        if !uiView.isFirstResponder && !forceResignFirstResponder {

            uiView.becomeFirstResponder()
        }
        else if forceResignFirstResponder {

            uiView.resignFirstResponder()
        }
        
        //Reduces space textfield takes up as much as possible
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

#if canImport(UIKit)
// To force SwiftUI to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func showKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
