//
//  EventService.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import Foundation


final class EventService: ObservableObject {
    static let shared = EventService()
    @Published var events: [Event] = []
    
    
    private init() { loadMock() }
    
    var bookmarkedEvents: [Event] {
            events.filter { $0.isBookmarked }
        }

        func toggleBookmark(for event: Event) {
            if let index = events.firstIndex(where: { $0.id == event.id }) {
                events[index].isBookmarked.toggle()
            }
        }
    
    private func loadMock() {
        events = [
            .init(id: .init(), title: "Jazz Night", description: "Live jazz by the lake", date: Date().addingTimeInterval(86400), location: "City Park", imageName: "jazz"),
            .init(id: .init(), title: "Tech Meetup", description: "SwiftUI deep dive.", date: Date().addingTimeInterval(172800), location: "Tech Hub", imageName: "tech")
        ]
    }
    
}
