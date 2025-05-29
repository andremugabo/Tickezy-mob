// ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthService
    @State private var showingLogoutConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    
                    if auth.isAuthenticated {
                        statsOverview
                    }
                    
                    settingsForm
                }
                .padding(.top, 20)
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Log Out", isPresented: $showingLogoutConfirmation) {
                Button("Log Out", role: .destructive) {
                    auth.logout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private var profileHeader: some View {
        VStack(spacing: 12) {
            if auth.isAuthenticated, let user = auth.currentUser {
                ZStack {
                    Circle()
                        .fill(Color.brandBlue.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.brandBlue)
                }
                
                VStack(spacing: 4) {
                    Text(user.displayName)
                        .font(.title2).bold()
                    
                    Text(user.username)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            } else {
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.secondary)
                
                Text("Guest")
                    .font(.title2).bold()
            }
        }
        .padding(.bottom, 20)
    }
    
    private var statsOverview: some View {
        HStack(spacing: 20) {
            StatView(count: "12", label: "Events")
            StatView(count: "5", label: "Bookmarks")
            StatView(count: "3", label: "Upcoming")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var settingsForm: some View {
        VStack(spacing: 0) {
            SettingsRow(icon: "person", title: "Account", color: .blue) {
                AccountSettingsView()
            }
            
            Divider().padding(.leading, 52)
            
            SettingsRow(icon: "bell", title: "Notifications", color: .red) {
                NotificationsView()
            }
            
            Divider().padding(.leading, 52)
            
            SettingsRow(icon: "paintbrush", title: "Appearance", color: .purple) {
                AppearanceSettingsView()
            }
            
            Divider().padding(.leading, 52)
            
            SettingsRow(icon: "questionmark.circle", title: "Help", color: .green) {
                HelpView()
            }
            
            if auth.isAuthenticated {
                Divider().padding(.leading, 52)
                
                Button {
                    showingLogoutConfirmation = true
                } label: {
                    SettingsRowContent(icon: "arrow.left.square", title: "Log Out", color: .red)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock environment
        let mockAuth = AuthService.shared
        
        // Simulate logged in state using your actual JSON data
        let loggedInView = ProfileView()
            .environmentObject(mockAuth)
            .task {
                // This simulates a successful login using your actual authentication flow
                mockAuth.login(
                    username: "user1@example.com", // Use a username from your users.json
                    password: "password123",       // Use the corresponding password
                    onSuccess: {},
                    onFailure: {}
                )
            }
        
        // Simulate guest state
        let guestView = ProfileView()
            .environmentObject(AuthService.shared)
        
        return Group {
            loggedInView
                .previewDisplayName("Logged In")
            
            guestView
                .previewDisplayName("Guest")
        }
    }
}

// MARK: - Supporting Views
struct StatView: View {
    let count: String
    let label: String
    
    var body: some View {
        VStack {
            Text(count)
                .font(.title3).bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsRow<Destination: View>: View {
    let icon: String
    let title: String
    let color: Color
    let destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()) {
            SettingsRowContent(icon: icon, title: title, color: color)
        }
    }
}

struct SettingsRowContent: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .contentShape(Rectangle())
    }
}
