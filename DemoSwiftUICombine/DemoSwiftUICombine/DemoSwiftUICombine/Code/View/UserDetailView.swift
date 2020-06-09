//
//  UserDetailView.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 02/06/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var mode:Binding<PresentationMode>
    @ObservedObject var user:User
    @State var currentFirstName:String = ""
    @State var currentLastName:String = ""
    var coreDataManager = CoreDataManager()
    
    var body: some View {
            VStack{
                Text("Edit user informations").font(.title)
                TextField("", text: $currentFirstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("", text: $currentLastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack(spacing: 150){
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }){
                        Text("Cancel")
                    }
                    Button(action: {
                        self.updateUser()
                    }){
                        Text("Save")
                    }
                }
                }.onAppear(perform: { self.initTextfieldValue() })
                .navigationBarTitle(Text("o"))
                .navigationBarHidden(true)
    }
    
    private func initTextfieldValue(){
        self.currentFirstName = user.firstName ?? ""
        self.currentLastName = user.lastName ?? ""
    }
    
    private func updateUser(){
            user.firstName = currentFirstName
            user.lastName = currentLastName
            coreDataManager.saveContext(context: moc)
            self.mode.wrappedValue.dismiss()
    }
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView()
//    }
//}

