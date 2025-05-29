//
//  TicketsView.swift
//  Tickezy
//
//  Created by M.A on 5/28/25.
//

import SwiftUI


struct TicketView: View {
    @State private var searchText = ""
    @State private var tickets: [Ticket] = []
    @State private var events: [Event] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    var filteredTickets: [TicketWithEvent] {
        let combined = combineTicketsWithEvents()
        if searchText.isEmpty {
            return combined
        } else {
            return combined.filter {
                $0.event.title.localizedCaseInsensitiveContains(searchText) ||
                $0.event.location.localizedCaseInsensitiveContains(searchText) ||
                $0.ticket.seat.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                headerView
                searchBar
                
                if isLoading {
                    loadingView
                } else if let error = error {
                    errorView(error: error)
                } else if filteredTickets.isEmpty {
                    emptyStateView
                } else {
                    ticketsListView
                }
            }
            .navigationBarHidden(true)
            .task {
                await loadData()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Tickets")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Upcoming events")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search tickets", text: $searchText)
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
                .padding()
            Text("Error loading tickets")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "ticket")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
                .padding()
            Text(searchText.isEmpty ? "You have no tickets yet" : "No tickets found")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var ticketsListView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(filteredTickets, id: \.ticket.id) { item in
                    NavigationLink(destination: TicketDetailView(ticketWithEvent: item)) {
                        TicketCard(ticketWithEvent: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    // MARK: - Data Methods
    
    private func combineTicketsWithEvents() -> [TicketWithEvent] {
        return tickets.compactMap { ticket in
            if let event = events.first(where: { $0.id == ticket.eventID }) {
                return TicketWithEvent(ticket: ticket, event: event)
            }
            return nil
        }
    }
    
    private func loadData() async {
        isLoading = true
        do {
            // Replace with your actual network calls
            tickets = try await MockNetworkService.shared.fetchTickets()
            events = try await MockNetworkService.shared.fetchEvents()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

// MARK: - Supporting Views

struct TicketCard: View {
    let ticketWithEvent: TicketWithEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(ticketWithEvent.event.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(ticketWithEvent.event.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(ticketWithEvent.event.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                AsyncImage(url: URL(string: ticketWithEvent.ticket.qrCode)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 60, height: 60)

            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Seat")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(ticketWithEvent.ticket.seat)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Category")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(ticketWithEvent.event.category)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct TicketDetailView: View {
    let ticketWithEvent: TicketWithEvent
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Event header
                VStack(alignment: .leading, spacing: 8) {
                    Text(ticketWithEvent.event.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(ticketWithEvent.event.date.formatted(date: .complete, time: .shortened))
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text(ticketWithEvent.event.location)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                // Event image
                Image(ticketWithEvent.event.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                // QR Code
                AsyncImage(url: URL(string: ticketWithEvent.ticket.qrCode)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 200, height: 200)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)

                
                // Ticket details
                VStack(spacing: 16) {
                    DetailRow(title: "Ticket ID", value: ticketWithEvent.ticket.id.uuidString)
                    DetailRow(title: "Event ID", value: ticketWithEvent.event.id.uuidString)
                    DetailRow(title: "Seat", value: ticketWithEvent.ticket.seat)
                    DetailRow(title: "Category", value: ticketWithEvent.event.category)
                }
                .padding()
                
                // Actions
                HStack(spacing: 16) {
                    Button(action: shareTicket) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: toggleBookmark) {
                        Label(
                            ticketWithEvent.event.isBookmarked ? "Bookmarked" : "Bookmark",
                            systemImage: ticketWithEvent.event.isBookmarked ? "bookmark.fill" : "bookmark"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationTitle("Ticket Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func shareTicket() {
        // Implement share functionality
    }
    
    private func toggleBookmark() {
        // Implement bookmark toggling
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Data Structures

struct TicketWithEvent {
    let ticket: Ticket
    let event: Event
}

// MARK: - Mock Network Service

class MockNetworkService {
    static let shared = MockNetworkService()
    
    func fetchTickets() async throws -> [Ticket] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        return [
            Ticket(
                eventID: UUID(uuidString: "1E1F1D1A-2B2C-3D3E-4F4A-5B5C6D7E8F9A")!,
                seat: "GA-25",
                qrCode: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TicketID:6BA7B810-9DAD-11D1-80B4-00C04FD430C8"
            ),
            Ticket(
                eventID: UUID(uuidString: "2A3B4C5D-6E7F-8091-A2B3-C4D5E6F7A8B9")!,
                seat: "VIP-1",
                qrCode: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TicketID:B1D3F23A-ACF9-44F1-B939-8B31F2B6CE1A"
            ),
            Ticket(
                eventID: UUID(uuidString: "3C4D5E6F-7A8B-9C0D-E1F2-3A4B5C6D7E8F")!,
                seat: "GA-42",
                qrCode: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TicketID:F4C21B73-E4A3-40E4-8E15-4CF47B6B6549"
            ),
            Ticket(
                eventID: UUID(uuidString: "4D5E6F7A-8B9C-0D1E-2F3A-4B5C6D7E8F9B")!, // replaced G -> B
                seat: "Balcony-12",
                qrCode: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TicketID:123E4567-E89B-12D3-A456-426614174000"
            ),
            Ticket(
                eventID: UUID(uuidString: "5E6F7A8B-9C0D-1E2F-3A4B-5C6D7E8F9A0B")!, // replaced G,H -> A,B
                seat: "Floor-5",
                qrCode: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TicketID:987F6543-E21B-45C3-B789-567843210000"
            ),
            Ticket(
                eventID: UUID(uuidString: "6F7A8B9C-0D1E-2F3A-4B5C-6D7E8F9A0B1C")!, // replaced G,H,I -> A,B,C
                seat: "Box-3",
                qrCode: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TicketID:ABC12345-6789-0DEF-1234-56789ABCDEF0"
            ),
            Ticket(
                eventID: UUID(uuidString: "7A8B9C0D-1E2F-3A4B-5C6D-7E8F9A0B1C2D")!, // replaced G,H,I,J -> A,B,C,D
                seat: "VIP-8",
                qrCode: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TicketID:DEF56789-1234-0ABC-5678-9DEF01234567"
            ),
            Ticket(
                eventID: UUID(uuidString: "8B9C0D1E-2F3A-4B5C-6D7E-8F9A0B1C2D3E")!, // replaced G,H,I,J,K -> A,B,C,D,E
                seat: "GA-10",
                qrCode: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TicketID:456789AB-CDEF-0123-4567-89ABCDEF0123"
            )
        ]
    }

    func fetchEvents() async throws -> [Event] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        return [
            Event(
                id: UUID(uuidString: "1E1F1D1A-2B2C-3D3E-4F4A-5B5C6D7E8F9A")!,
                title: "Battain Concert",
                description: "Annual music festival featuring top artists",
                date: Date().addingTimeInterval(86400 * 7),
                location: "Grand Center, Nebraska",
                imageName: "concert",
                isBookmarked: false,
                category: "Music"
            ),
            Event(
                id: UUID(uuidString: "2A3B4C5D-6E7F-8091-A2B3-C4D5E6F7A8B9")!,
                title: "Global Tech Summit",
                description: "Conference on emerging technologies and innovation",
                date: Date().addingTimeInterval(86400 * 14),
                location: "San Francisco, CA",
                imageName: "tech",
                isBookmarked: false,
                category: "Technology"
            ),
            Event(
                id: UUID(uuidString: "3C4D5E6F-7A8B-9C0D-E1F2-3A4B5C6D7E8F")!,
                title: "Eco Wellness Retreat",
                description: "A holistic weekend focused on health and sustainability",
                date: Date().addingTimeInterval(86400 * 21),
                location: "Sedona, Arizona",
                imageName: "wellness",
                isBookmarked: false,
                category: "Health"
            ),
            Event(
                id: UUID(uuidString: "4D5E6F7A-8B9C-0D1E-2F3A-4B5C6D7E8F9B")!, // replaced G -> B
                title: "Modern Art Expo",
                description: "Exhibition showcasing modern art from around the world",
                date: Date().addingTimeInterval(86400 * 28),
                location: "New York, NY",
                imageName: "artexpo",
                isBookmarked: false,
                category: "Art"
            ),
            Event(
                id: UUID(uuidString: "5E6F7A8B-9C0D-1E2F-3A4B-5C6D7E8F9A0B")!, // replaced G,H -> A,B
                title: "International Food Festival",
                description: "Taste dishes from 50+ countries in one place",
                date: Date().addingTimeInterval(86400 * 35),
                location: "Chicago, IL",
                imageName: "foodfest",
                isBookmarked: false,
                category: "Food"
            ),
            Event(
                id: UUID(uuidString: "6F7A8B9C-0D1E-2F3A-4B5C-6D7E8F9A0B1C")!, // replaced G,H,I -> A,B,C
                title: "Startup Pitch Night",
                description: "Pitch your startup ideas to top investors",
                date: Date().addingTimeInterval(86400 * 42),
                location: "Austin, TX",
                imageName: "startup",
                isBookmarked: false,
                category: "Business"
            ),
            Event(
                id: UUID(uuidString: "7A8B9C0D-1E2F-3A4B-5C6D-7E8F9A0B1C2D")!, // replaced G,H,I,J -> A,B,C,D
                title: "Jazz & Blues Festival",
                description: "Weekend of jazz and blues performances by renowned artists",
                date: Date().addingTimeInterval(86400 * 49),
                location: "New Orleans, LA",
                imageName: "jazz",
                isBookmarked: false,
                category: "Music"
            ),
            Event(
                id: UUID(uuidString: "8B9C0D1E-2F3A-4B5C-6D7E-8F9A0B1C2D3E")!, 
                title: "Marathon for Charity",
                description: "Run to support local charities and community projects",
                date: Date().addingTimeInterval(86400 * 56),
                location: "Boston, MA",
                imageName: "marathon",
                isBookmarked: false,
                category: "Sports"
            )
        ]
    }

}

// MARK: - Preview

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView()
    }
}
