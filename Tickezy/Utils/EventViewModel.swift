//
//  EventViewModel.swift
//  Tickezy
//
//  Created by M.A on 5/28/25.
//

import Foundation
import Combine

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var error: Error?

    func fetchEvents() {
        isLoading = true
        
        // Dispatch async so UI doesn't block
        DispatchQueue.global(qos: .background).async {
            do {
                // Locate the JSON file in the app bundle
                guard let url = Bundle.main.url(forResource: "events", withExtension: "json", subdirectory: "resources/MockData") else {
                    throw NSError(domain: "File not found", code: 404, userInfo: nil)
                }
                
                // Read data from the file
                let data = try Data(contentsOf: url)
                
                // Decode JSON data into array of Event
                let decodedEvents = try JSONDecoder().decode([Event].self, from: data)
                
                // Switch back to main thread to publish
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

    func fetchEventDetails(eventId: String) -> Event? {
        guard let uuid = UUID(uuidString: eventId) else {
            print("Invalid UUID string: \(eventId)")
            return nil
        }
        return events.first { $0.id == uuid }
    }
}
