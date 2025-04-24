//
//  Untitled.swift
//  Quasar
//
//  Created by Basem Elkady on 4/23/25.
//

struct ArticleResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Article]
}
