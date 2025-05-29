//
//  loadEvents.swift
//  Tickezy
//
//  Created by M.A on 5/28/25.
//


import Foundation


func loadEvents() -> [Event] {
    guard let url = Bundle.main.url(forResource: "events", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("Failed to load event.json")
        return []
    }
    do {
        let events = try JSONDecoder().decode([Event].self, from: data)
        return events
    } catch {
        print("Failed to decode events: \(error)")
        return []
    }
}
