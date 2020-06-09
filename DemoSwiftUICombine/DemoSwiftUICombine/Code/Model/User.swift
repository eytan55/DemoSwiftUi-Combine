//
//  User.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 31/05/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject, Identifiable, Codable {
    
    @NSManaged public var id:Int32
    @NSManaged public var firstName:String?
    @NSManaged public var lastName:String?
    @NSManaged public var email:String?
    @NSManaged public var avatar:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case avatar
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
        let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
            fatalError("Failed to retrieve entity")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        // MARK: - Decodable
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int32.self, forKey: .id)!
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(avatar, forKey: .avatar)
    }
}

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

