//
//  ContentView.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 28/05/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State var action:Int? = 0
    var connexionManager = ConnexionManager()
    @State var show = false
    @State var disablePopup = true
    
    var body: some View {
        ZStack(){
            NavigationView {
                NavigationLink(destination: UserListPageView(), tag: 1, selection: $action) {
                    Text("UserListButton").onTapGesture {
                        self.connexionManager.get()
                        self.disablePopup.toggle()
                        self.action = 1
                    }
                }
            }
            if disablePopup{
                Button(action: {
                    withAnimation{
                        self.show.toggle()
                    }
                }, label: {
                    Text("Popup")
                })
                
                if self.show{
                    PopupView(isPresented: self.$show)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
