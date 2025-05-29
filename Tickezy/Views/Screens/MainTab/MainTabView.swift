//
//  MainTabView.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {Label("Home", systemImage: "house")}
            BookmarksView()
                .tabItem {Label("Bookmarks", systemImage: "bookmark")}
            TicketView()
                .tabItem {Label("Tickets", systemImage: "ticket")}
            ProfileView()
                .tabItem {Label("Profile", systemImage: "person.circle")}
        }
    }
}

