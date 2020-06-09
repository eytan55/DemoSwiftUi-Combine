//
//  JsonToObject.swift
//  DemoSwiftUICombine
//
//  Created by eytan taieb on 01/06/2020.
//  Copyright © 2020 eytan taieb. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Main
class Main: Decodable {
    var page, perPage, total, totalPages: Int
    var data: [User]

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
    }

    init(page: Int, perPage: Int, total: Int, totalPages: Int, data: [User]) {
        self.page = page
        self.perPage = perPage
        self.total = total
        self.totalPages = totalPages
        self.data = data
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(Int.self, forKey: .page)
        perPage = try values.decode(Int.self, forKey: .perPage)
        total = try values.decode(Int.self, forKey: .total)
        totalPages = try values.decode(Int.self, forKey: .totalPages)
        data = try values.decode([User].self, forKey: .data)
    }
}
