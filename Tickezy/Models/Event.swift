//
//  Event.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let location: String
    let imageName: String
    var isBookmarked: Bool
    let category: String

    enum CodingKeys: String, CodingKey {
        case id, title, description, date, location, imageName, isBookmarked, category
    }

    // ✅ Add this manual initializer
    init(id: UUID, title: String, description: String, date: Date, location: String, imageName: String, isBookmarked: Bool, category: String) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.location = location
        self.imageName = imageName
        self.isBookmarked = isBookmarked
        self.category = category
    }

    // Your custom decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        guard let uuid = UUID(uuidString: idString) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Invalid UUID string")
        }
        id = uuid
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        date = try container.decode(Date.self, forKey: .date)
        location = try container.decode(String.self, forKey: .location)
        imageName = try container.decode(String.self, forKey: .imageName)
        isBookmarked = try container.decode(Bool.self, forKey: .isBookmarked)
        category = try container.decode(String.self, forKey: .category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(date, forKey: .date)
        try container.encode(location, forKey: .location)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(isBookmarked, forKey: .isBookmarked)
        try container.encode(category, forKey: .category)
    }
}
