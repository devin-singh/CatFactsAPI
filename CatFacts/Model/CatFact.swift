//
//  CatFact.swift
//  CatFacts
//
//  Created by Devin Singh on 1/23/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

struct TopLevelGETObject: Decodable {
    let page: Int
    let total: Int
    let totalPages: Int
    let facts: [CatFact]
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case page
        case total
        case facts
    }
}

struct TopLevelPOSTObject: Encodable {
    let fact: CatFact
}

struct CatFact: Codable {
    let id: Int?
    let details: String
}
