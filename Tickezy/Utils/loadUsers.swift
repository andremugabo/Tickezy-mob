//
//  loadUsers.swift
//  Tickezy
//
//  Created by M.A on 5/26/25.
//

import Foundation



func loadUsers() -> [User] {
    guard let url = Bundle.main.url(forResource: "users", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("Failed to load users.json")
        return []
    }
    
    do {
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    } catch {
        print("Failed to decode users: \(error)")
        return []
    }
}
