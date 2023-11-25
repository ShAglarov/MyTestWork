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
    @Published var newsError: String? = nil
    
    private let provider = NetworkManager()
    
    func performGetNews(searchNews: String) async {
        isLoading = true
        do {
            let fetchedNews = try await provider.getNews(searchQuery: searchNews)
            await MainActor.run { [weak self] in
                self?.news = fetchedNews.articles
                self?.isLoading = false
            }
        } catch {
            newsError = "Ошибка: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
