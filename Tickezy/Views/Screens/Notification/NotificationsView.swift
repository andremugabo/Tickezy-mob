//
//  NotificationsView.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI



struct NotificationsView: View {
    @State private var notifications: [Notification] = [
        .init(id: UUID(), message: "Your ticket for Jazz Night is confirmed", date: Date().addingTimeInterval(-3600)),
        .init(id: UUID(), message: "Food Festival added to your calendar", date: Date().addingTimeInterval(-86400))
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if notifications.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "bell.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No notifications yet.")
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                        Spacer()
                    }
                } else {
                    List(notifications) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.message)
                                .fontWeight(.medium)
                            Text(note.date, style: .relative)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Notifications")
        }
    }
}



