//
//  Article.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import Foundation

struct Article: Decodable {
    
    let id: Int
    let title: String
    let url: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let publishedAt: String
}
