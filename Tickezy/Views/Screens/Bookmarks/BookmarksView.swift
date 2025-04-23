import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var eventSvc: EventService

    var body: some View {
        NavigationStack {
            Group {
                if eventSvc.bookmarkedEvents.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "bookmark.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("You haven’t bookmarked any events yet.")
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(eventSvc.bookmarkedEvents) { event in
                            NavigationLink(value: event) {
                                EventRow(event: event)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let event = eventSvc.bookmarkedEvents[index]
                                eventSvc.toggleBookmark(for: event)
                            }
                        }
                    }
                    .navigationDestination(for: Event.self) { event in
                        EventDetailView(event: event)
                    }
                    .refreshable {
                        // optional: trigger any reload logic if needed
                    }
                }
            }
            .navigationTitle("Bookmarks")
        }
    }
}
