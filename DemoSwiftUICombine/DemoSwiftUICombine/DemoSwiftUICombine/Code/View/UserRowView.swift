//
//  UserDetailView.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 02/06/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import SwiftUI



struct UserRowView: View {
    public var user:User
    
    var body: some View {
        HStack{
//            Image("")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
            Text("\(user.firstName ?? "")")
            Text("\(user.lastName ?? "")")
        }
        
    }
}

//struct UserRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRowView()
//    }
//}
