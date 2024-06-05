//
//  User.swift
//  iOS Concurrency
//
//  Created by Jayanth Ambaldhage on 01/06/24.
//

import Foundation

//source: https://jsonplaceholder.typicode.com/users

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
