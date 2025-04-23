//
//  Event.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import Foundation

struct Event: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let location: String
    let imageName: String
    var isBookmarked: Bool = false
}
