//
//  ConnexionManager.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 28/05/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Combine

class ConnexionManager: ObservableObject {
    
    private var task: AnyCancellable?
    var coreDataManager = CoreDataManager()
    
    enum HTTPError: LocalizedError {
        case statusCode
    }
    
    enum APIError: Error {
        case encode(EncodingError)
        case request(URLError)
        case decode(DecodingError)
        case unknown
    }
    
    public func get(){
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve managed object context")
        }
        
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let managedObjectContext = persistentContainer.viewContext
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        let url = URL(string: "https://reqres.in/api/users")!
        task = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
        }
        .decode(type: Main.self, decoder: decoder)
        .tryMap { output in
            return output.data
        }
        .replaceError(with: [])
        .eraseToAnyPublisher()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                print("Success")
                self.coreDataManager.saveContext(context: managedObjectContext)
            }
        }, receiveValue: { (value) in
            // print("value: ", value)
        })
    }
    
    public static func post(userList:[User] = []) -> AnyPublisher<[User], APIError>{
        return Just(userList)
            .encode(encoder: JSONEncoder())
            .mapError { error -> APIError in
                if let encodingError = error as? EncodingError {
                    return .encode(encodingError)
                } else {
                    return .unknown
                }
        }
        .map { data -> URLRequest in
            let url = URL(string: "exemplePostUrl")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
            return urlRequest
        }.flatMap {
            URLSession.shared.dataTaskPublisher(for: $0)
                .mapError(APIError.request)
                .map(\.data)
                .decode(type: [User].self, decoder: JSONDecoder())
                .mapError { error -> APIError in
                    if let decodingError = error as? DecodingError {
                        return .decode(decodingError)
                    } else {
                        return .unknown
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func delete(idToDelete: Int32) -> AnyPublisher<[User], APIError>{
        let parameters = ["ID": idToDelete] as [String : Int32]
        return Just(parameters)
            .encode(encoder: JSONEncoder())
            .mapError { error -> APIError in
                if let encodingError = error as? EncodingError {
                    return .encode(encodingError)
                } else {
                    return .unknown
                }
        }
        .map { data -> URLRequest in
            let url = URL(string: "exempleDeleteUrl")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
            return urlRequest
        }.flatMap {
            URLSession.shared.dataTaskPublisher(for: $0)
                .mapError(APIError.request)
                .map(\.data)
                .decode(type: [User].self, decoder: JSONDecoder())
                .mapError { error -> APIError in
                    if let decodingError = error as? DecodingError {
                        return .decode(decodingError)
                    } else {
                        return .unknown
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
