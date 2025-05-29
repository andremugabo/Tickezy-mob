//
//  EventService.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import Foundation
import OSLog

final class EventService: ObservableObject {
    static let shared = EventService()
    
    // MARK: - Published Properties
    @Published private(set) var events: [Event] = []
    @Published private(set) var featuredEvent: Event?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    // MARK: - Private Properties
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.Tickezy",
        category: String(describing: EventService.self)
    )
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private let jsonEncoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard
    private let bookmarksKey = "savedEventBookmarks"
    
    // MARK: - Initialization
    private init() {
        loadEvents()
    }
    
    // MARK: - Public Interface
    var bookmarkedEvents: [Event] {
        events.filter { $0.isBookmarked }
    }
    
    func toggleBookmark(for event: Event) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        
        events[index].isBookmarked.toggle()
        saveBookmarks()
        
        if featuredEvent?.id == event.id {
            featuredEvent?.isBookmarked.toggle()
        }
    }
    
    func refreshEvents() {
        loadEvents()
    }
    
    // MARK: - Data Loading
    func loadEvents() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                // Load from bundled JSON
                let data = try self.loadBundledEvents()
                let decodedEvents = try self.decodeEvents(data: data)
                let eventsWithBookmarks = self.applySavedBookmarks(to: decodedEvents)
                
                DispatchQueue.main.async {
                    self.events = eventsWithBookmarks.sorted { $0.date < $1.date }
                    self.featuredEvent = self.determineFeaturedEvent()
                    self.isLoading = false
                    self.logger.debug("Successfully loaded \(self.events.count) events")
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                    self.logger.error("Failed to load events: \(error.localizedDescription)")
                    // No fallback since we expect the bundled JSON to always be available
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func loadBundledEvents() throws -> Data {
        guard let url = Bundle.main.url(forResource: "events", withExtension: "json") else {
            throw EventServiceError.fileNotFound(filename: "events.json")
        }
        return try Data(contentsOf: url)
    }
    
    private func decodeEvents(data: Data) throws -> [Event] {
        do {
            let response = try jsonDecoder.decode(EventResponse.self, from: data)
            return response.events
        } catch {
            logger.error("Decoding failed: \(error.localizedDescription)")
            throw EventServiceError.decodingFailed(error)
        }
    }
    
    private func applySavedBookmarks(to events: [Event]) -> [Event] {
        let savedBookmarkIDs = loadSavedBookmarkIDs()
        return events.map { event in
            var modifiedEvent = event
            modifiedEvent.isBookmarked = savedBookmarkIDs.contains(event.id)
            return modifiedEvent
        }
    }
    
    private func determineFeaturedEvent() -> Event? {
        // Simple logic - could be enhanced with more complex rules
        return events.first
    }
    
    // MARK: - Bookmark Persistence
    private func saveBookmarks() {
        let bookmarkedIDs = events.filter { $0.isBookmarked }.map { $0.id }
        userDefaults.set(bookmarkedIDs.map { $0.uuidString }, forKey: bookmarksKey)
        logger.debug("Saved \(bookmarkedIDs.count) bookmarks")
    }
    
    private func loadSavedBookmarkIDs() -> [UUID] {
        guard let idStrings = userDefaults.stringArray(forKey: bookmarksKey) else {
            return []
        }
        return idStrings.compactMap { UUID(uuidString: $0) }
    }
    
    // MARK: - Debug
    #if DEBUG
    convenience init(mockEvents: [Event]) {
        self.init()
        self.events = mockEvents
        self.featuredEvent = mockEvents.first
    }
    #endif
}

// MARK: - Supporting Types
struct EventResponse: Codable {
    let events: [Event]
}

enum EventServiceError: LocalizedError {
    case fileNotFound(filename: String)
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "Could not find \(filename) in app bundle"
        case .decodingFailed(let error):
            return "Failed to decode events: \(error.localizedDescription)"
        }
    }
}
