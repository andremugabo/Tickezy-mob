import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading) {
                        if !viewModel.featuredEvents.isEmpty {
                            Text("Featured Events")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.featuredEvents) { event in
                                        EventCard(event: event)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        Text("Upcoming Events")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top)

                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.upcomingEvents) { event in
                                EventRow(event: event)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Show notifications
                    }) {
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        NavigationLink(destination: EventDetailView(event: event)) {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: event.imageName)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 200, height: 120)
                .cornerRadius(10)
                
                Text(event.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(width: 200)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
