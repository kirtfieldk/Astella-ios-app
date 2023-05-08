//
//  EventPasswordModal.swift
//  Astella
//
//  Created by Keith Kirtfield on 5/5/23.
//

import SwiftUI

struct EventPasswordModal: View {
    @State private var passcode: String = ""
    @FocusState private var emailFieldIsFocused : Bool

    
        var body: some View {
            
            VStack {
                Label("Passcode", systemImage: ".person")
                    .underline(color: .red)
                TextField("Passcode", text: $passcode)
                .focused($emailFieldIsFocused)
                   
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .textFieldStyle(.roundedBorder)

                    Text(passcode)
                        .foregroundColor(emailFieldIsFocused ? .red : .blue)
                Button("Enter", action: printHello)
                    .padding(12)
                    .background(.red)
                    .fontWeight(.heavy)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100, height: 30, alignment: .trailing)
                    
                
                    .frame(alignment: .bottomTrailing)
            }
            .frame(width: .infinity, height: 150)
            .border(.black)
            .background(.cyan)
            .cornerRadius(12)
//            .shadow(color: .black, radius: 5.0, x: 3, y: 6)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
        }
    
    func printHello() {
        print("HELLO WORLD")
    }
}

struct EventPasswordModal_Previews: PreviewProvider {
    static var previews: some View {
        EventPasswordModal()
    }
}
