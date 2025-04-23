//
//  ContentView.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthService
    var body: some View {
        Group {
            if auth.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: auth.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
