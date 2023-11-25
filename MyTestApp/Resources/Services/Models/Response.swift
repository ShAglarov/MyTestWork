//
//  Responce.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 03.11.2023.
//

struct Response: Codable {
    var articles: [OneNews]
}

struct OneNews: Codable {
    var author: String?
    var title: String?
}
