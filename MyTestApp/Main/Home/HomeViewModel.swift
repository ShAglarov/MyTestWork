//
//  HomeViewModel.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import Foundation
import Moya
import Combine

final class HomeViewModel {

    @Published var combinedUsers: [CombinedUser] = []  // Исправлено
    @Published var posts: Posts = []
    @Published var users: Users = []
    @Published var photos: Photos = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil

    private let provider = MoyaProvider<JSONPlaceholderAPI>()
    var cancellables: Set<AnyCancellable> = []

    func fetchData() {
        fetchPosts()
        fetchUsers()
        fetchPhotos()
    }

    func fetchPosts() {
        isLoading = true
        error = nil
        
        provider.request(.posts) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                do {
                    self?.posts = try JSONDecoder().decode(Posts.self, from: response.data)
                    self?.combinedUsers = self?.combineData(users: self?.users ?? [], 
                                                            posts: self?.posts ?? [],
                                                            photos: self?.photos ?? []) ?? []
                } catch {
                    self?.error = "Error decoding posts: \(error)"
                }
            case .failure(let moyaError):
                self?.error = "Error fetching posts: \(moyaError)"
            }
        }
    }

    func fetchUsers() {
        isLoading = true
        error = nil

        provider.request(.users) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                do {
                    self?.users = try JSONDecoder().decode(Users.self, from: response.data)
                    self?.combinedUsers = self?.combineData(users: self?.users ?? [], 
                                                            posts: self?.posts ?? [],
                                                            photos: self?.photos ?? []) ?? []
                } catch {
                    self?.error = "Error decoding users: \(error)"
                }
            case .failure(let moyaError):
                self?.error = "Error fetching users: \(moyaError)"
            }
        }
    }

    func fetchPhotos() {
        isLoading = true
        error = nil

        provider.request(.photos) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                do {
                    self?.photos = try JSONDecoder().decode(Photos.self, from: response.data)
                    self?.combinedUsers = self?.combineData(users: self?.users ?? [], 
                                                            posts: self?.posts ?? [],
                                                            photos: self?.photos ?? []) ?? []
                } catch {
                    self?.error = "Error decoding photos: \(error)"
                }
            case .failure(let moyaError):
                self?.error = "Error fetching photos: \(moyaError)"
            }
        }
    }
    
    func combineData(users: Users, posts: Posts, photos: Photos) -> [CombinedUser] {
        return users.compactMap { user in
            let userPosts = posts.filter { $0.userID == user.id }
            let userPhotos = photos.filter { $0.albumID == user.id }
            return CombinedUser(user: user, posts: userPosts, photos: userPhotos)
        }
    }
}
