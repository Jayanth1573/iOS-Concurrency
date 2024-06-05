//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Jayanth Ambaldhage on 01/06/24.
//

import Foundation

class UsersListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    @MainActor
    func fetchUsers() async {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        defer {
            isLoading.toggle()
        }
        
        do {
            users = try await apiService.getJSON()
        } catch {
            self.showAlert = true
            self.errorMessage = error.localizedDescription + "\n Please contact the developer "
        }
       
        
        
        //        apiService.getJSON { (result: Result<[User], APIError>) in
        //            defer {
        //                DispatchQueue.main.async {
        //                    self.isLoading.toggle()
        //                }
        //            }
        //            switch result {
        //            case .success(let users):
        //                DispatchQueue.main.async {
        //                    self.users = users
        //                }
        //            case .failure(let error):
        //                DispatchQueue.main.async {
        //                    self.showAlert = true
        //                    self.errorMessage = error.localizedDescription + "\n Please contact the developer "
        //                }
        //            }
        //        }
    }
}

extension UsersListViewModel {
    convenience init (forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.users = User.mockUsers
        }
    }
}
