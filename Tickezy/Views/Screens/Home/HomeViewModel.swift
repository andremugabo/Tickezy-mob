//
//  HomeViewModel.swift
//  Tickezy
//
//  Created by M.A on 5/28/25.
//

import Foundation
import Combine
import SwiftUI



class HomeViewModel: ObservableObject {
    @Published private(set) var events: [Event] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchEvents()
    }
    
    func fetchEvents() {
        isLoading = true
        
        DispatchQueue.global(qos: .background).async {
            do {
                guard let url = Bundle.main.url(forResource: "events", withExtension: "json", subdirectory: "resources/MockData") else {
                    throw NSError(domain: "File not found", code: 404, userInfo: nil)
                }
                
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let decodedEvents = try decoder.decode([Event].self, from: data)
                
                DispatchQueue.main.async {
                    self.events = decodedEvents
                    self.isLoading = false
                    self.error = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    var featuredEvents: [Event] {
        events.filter { $0.isBookmarked }
    }
    
    var upcomingEvents: [Event] {
        let now = Date()
        return events.filter { $0.date >= now && !$0.isBookmarked }
                     .sorted(by: { $0.date < $1.date })
    }
}
