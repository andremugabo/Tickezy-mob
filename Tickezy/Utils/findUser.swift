//
//  login.swift
//  Tickezy
//
//  Created by M.A on 5/26/25.
//

import Foundation


func findUser(username: String, password: String, users: [User]) -> User? {
    return users.first(where: { $0.username == username && $0.password == password })
}

