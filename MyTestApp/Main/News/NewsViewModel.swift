//
//  NewsViewModel.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 03.11.2023.
//

import Combine

final class NewsViewModel {
    
    @Published var news: [OneNews] = []
    @Published var isLoading: Bool = false
    
    private let provider = NetworkManager()
    
    func fetchNews(searchQuery: String) {
        isLoading = true
        provider.getNews(value: searchQuery, limit: "20", completion: { [weak self] result in
            self?.isLoading = false
            switch result {
            case .failure(let error):
                print("Ошибка \(error.localizedDescription)")
            case .success(let articles):
                self?.news = articles
            }
        })
    }
}
