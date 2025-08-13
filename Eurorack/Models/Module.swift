//
//  Module.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-10.
//

import Foundation

struct Module: Hashable, Identifiable, Codable {
    let id: Int
    let name: String
    let manufacturer: String
    let description: String
    let width: String
    let url: String
    let thumbnailUrl: String
    let imgUrl: String?
    let price: String?
    let categories: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case manufacturer
        case description = "desc"
        case width
        case url
        case thumbnailUrl = "thumb_url"
        case imgUrl = "img_url"
        case price
        case categories
    }
}
