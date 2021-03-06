//
//  Article.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import Foundation



/// This is the Article Model which gonna be used to decode the JSON object we'd recive from after a successful network call
struct Article: Decodable {
    
    let id: Int
    let title: String
    let url: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let publishedAt: String
}
