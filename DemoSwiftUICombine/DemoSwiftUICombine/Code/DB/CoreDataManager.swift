//
//  CoreDataManager.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 28/05/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Combine

class CoreDataManager: ObservableObject {
    
    var willChange = PassthroughSubject<Void,Never>()
    var dataLoaded:Bool = false {
        didSet{
            willChange.send()
       }
    }
    
    public func saveContext(context: NSManagedObjectContext){
            do{
                try context.save()
                dataLoaded = true
            } catch let error {
                print(error.localizedDescription)
            }
    }
    
    public static func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            print ("deleteAllRecords: success")
        } catch {
            print ("There was an error")
        }
    }
}

