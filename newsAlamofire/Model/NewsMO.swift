//
//  NewsMO.swift
//  newsAlamofire
//
//  Created by Massimiliano Bonafede on 16/02/22.
//  Copyright © 2022 Massimiliano Bonafede. All rights reserved.
//

import Foundation

struct NewsMO: Decodable {
    let status: String
    let articles: [ArticleMO]
    let totalResults: Int
}

struct ArticleMO: Decodable {
    let source: SourceMO?
    let author: String?
    let urlToImage: String?
    let content: String?
    let title: String?
    let publishedAt: String?
    let description: String?
    let url: String?
}

struct SourceMO: Decodable {
    let id: String?
    let name: String?
}
