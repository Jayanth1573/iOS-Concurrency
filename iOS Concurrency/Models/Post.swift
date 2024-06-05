//
//  Post.swift
//  iOS Concurrency
//
//  Created by Jayanth Ambaldhage on 01/06/24.
//

import Foundation
//source: https://jsonplaceholder.typicode.com/posts
//single user's posts: https://jsonplaceholder.typicode.com/users/1/posts

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
