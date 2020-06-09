//
//  UserController.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 01/06/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import Foundation
import CoreData
import Combine
import UIKit

class UserController {
    
    //private let persistentContainer: NSPersistentContainer
    private var task: AnyCancellable?
    @Published var userList:[User] = []

    
    enum HTTPError: LocalizedError {
        case statusCode
    }
    
//    init(persistentContainer: NSPersistentContainer) {
//        self.persistentContainer = persistentContainer
//    }
    
    public func parse() -> Bool {
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve managed object context")
            }
        
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
            
            // Parse JSON data
            let managedObjectContext = persistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        print("decoder.userInfo: ", decoder.userInfo)
                    let url = URL(string: "https://reqres.in/api/users")!
                    task = URLSession.shared.dataTaskPublisher(for: url)
            //        .map { self.decodeJson(data: $0.data)  }
            //        .map { $0.data  }
                        .tryMap { output in
                            guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                                print("HTTPError.statusCode")
                                throw HTTPError.statusCode
                            }
                            print("output.data: ", output.data)
                            return output.data
                        }
                    .decode(type: Main.self, decoder: decoder)
            //        .replaceError(with: [])
                    .eraseToAnyPublisher()
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { (completion) in
                        switch completion {
                        case .failure(let error):
                            print(error)
                        case .finished:
                            print("Success")
                        }
                    }, receiveValue: { (value) in
                        print("value: ", value)
                    })
            //        .assign(to: \ConnexionManager.userList, on: self)
                    return true
            }

}

extension UserController {

}
