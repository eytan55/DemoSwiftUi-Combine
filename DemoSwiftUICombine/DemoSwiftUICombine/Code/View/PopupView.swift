//
//  PopupView.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 03/06/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import SwiftUI

struct PopupView: View {
    @Binding var isPresented:Bool
    
    var body: some View {
        GeometryReader{_ in
            HStack(spacing: 150) {
                Button(action: {
                    print("in Cancel button")
                    self.isPresented.toggle()
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    print("in Ok button")
                    self.isPresented.toggle()
                }) {
                    Text("Ok")
                }
            }.padding()
                .background(Color.white)
                .cornerRadius(15)
            
        }.background(
            Color.black.opacity(0.65)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation{
                        self.isPresented.toggle()
                    }
            }
        )
        
    }
}

//struct PopupView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopupView()
//    }
//}
