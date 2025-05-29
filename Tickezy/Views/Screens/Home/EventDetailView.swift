import SwiftUI

struct EventDetailView: View {
    let event: Event
    @State private var isBookmarked: Bool
    
    init(event: Event) {
        self.event = event
        self._isBookmarked = State(initialValue: event.isBookmarked)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image with Bookmark Button
                AsyncImage(url: URL(string: event.imageName)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        isBookmarked.toggle()
                        // Insert bookmarking logic here (e.g., update model/store)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .foregroundColor(isBookmarked ? .yellow : .white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.4)))
                    }
                    .padding()
                }
                
                // Event Content
                VStack(alignment: .leading, spacing: 20) {
                    // Category & Date
                    HStack {
                        Text(event.category)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        
                        Spacer()
                        
                        Text(event.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Title
                    Text(event.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                    
                    // Location Info
                    Label(event.location, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Attendees
                    Label("1.2K Going", systemImage: "person.2.fill")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    // Description
                    Text("About the Event")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(event.description)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.primary)
                    
                    Spacer().frame(height: 30)
                    
                    // Buttons
                    VStack(spacing: 12) {
                        ButtonPrimary(title: "Buy Tickets") {
                            // Implement ticket purchase logic here
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        
                        ButtonSecondary(title: "Share Event") {
                            // Share logic here
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct ButtonSecondary: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .foregroundColor(.primary)
                .cornerRadius(10)
        }
    }
}
