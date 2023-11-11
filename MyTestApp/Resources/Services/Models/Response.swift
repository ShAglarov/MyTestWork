//
//  Responce.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 03.11.2023.
//

struct Response: Decodable {
    var articles: [OneNews]
}

struct OneNews: Decodable {
    var author: String?
    var title: String?
}
