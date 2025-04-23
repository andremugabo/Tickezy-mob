//
//  ProfileView.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthService
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let user = auth.currentUser {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.brandBlue)
                    Text(user.displayName)
                        .font(.title2).bold()
                    Text(user.username)
                        .foregroundColor(.secondary)
                } else {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.secondary)
                    Text("Geust")
                        .font(.title2).bold()
                }
                Form {
                    Section {
                        NavigationLink("Personal Settings", value: "personal")
                        NavigationLink("General", value: "general")
                        NavigationLink("Notifications", value: "notifications")
                        NavigationLink("Help", value: "help")
                    }
                    Section {
                        Button("LogOut", role: .destructive){
                            auth.logout()
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
            .padding(.top, 30)
            .navigationTitle("Profile")
        }
    }
}

