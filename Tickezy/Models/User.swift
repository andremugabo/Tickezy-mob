//
//  User.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let username: String
    let displayName: String
    let password: String
}

