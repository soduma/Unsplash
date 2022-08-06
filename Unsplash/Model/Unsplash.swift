//
//  Unsplash.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/13.
//

import Foundation

struct Unsplash: Codable {
    let results: [Results]
}

struct Results: Codable {
    let id: String
    let blurHash: String
    let description: String?
    let altDescription: String?
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id, description, urls
        case blurHash = "blur_hash"
        case altDescription = "alt_description"
    }
}

struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
}
