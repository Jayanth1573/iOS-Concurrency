//
//  PostsListViewModel.swift
//  iOS Concurrency
//
//  Created by Jayanth Ambaldhage on 03/06/24.
//

import Foundation

class PostsListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    var userId: Int?
    @MainActor
    
    
    func fetchPosts() async {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            
            
            defer {
                isLoading.toggle()
            }
            
            do {
                posts = try await apiService.getJSON()
            } catch {
                self.showAlert = true
                self.errorMessage = error.localizedDescription + "\n Please contact the developer "
            }
            
//            isLoading.toggle()
//            apiService.getJSON { (result: Result<[Post], APIError>) in
//                defer {
//                    DispatchQueue.main.async {
//                        self.isLoading.toggle()
//                    }
//                }
//                switch result {
//                case .success(let posts):
//                    DispatchQueue.main.async {
//                        self.posts = posts
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self.showAlert = true
//                        self.errorMessage = error.localizedDescription + "\n Please contact the developer "
//                    }
//                }
//            }
        }
    }
}

extension PostsListViewModel {
    convenience init (forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.posts = Post.mockSingleUsersPostsArray
        }
    }
}
