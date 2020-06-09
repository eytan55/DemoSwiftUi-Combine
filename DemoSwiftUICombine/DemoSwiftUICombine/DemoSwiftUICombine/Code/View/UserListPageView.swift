//
//  UserListPageView.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 28/05/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import SwiftUI

struct UserListPageView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var users: FetchedResults<User>
    @State private var refreshing = false
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.id){user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        HStack{
                            ImageView(withURL: user.avatar ?? "")
                            VStack(alignment: .leading){
                                Text("\(user.firstName ?? "") " + (self.refreshing ? "" : "") + "\(user.lastName ?? "")")
                                Text("\(user.email ?? "")").font(.caption)
                            }
                        }
                    }.onReceive(self.didSave) { _ in
                        self.refreshing.toggle()
                    }
                }
            }
        }
            .navigationBarTitle(Text("o"))
            .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
    
    struct UserListPageView_Previews: PreviewProvider {
        static var previews: some View {
            UserListPageView()
        }
    }
}
