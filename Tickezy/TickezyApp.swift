//
//  TickezyApp.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

@main
struct TickezyApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var auth = AuthService.shared
    @StateObject private var events = EventService.shared
    @StateObject private var tickets = TicketService.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .environmentObject(auth)
                .environmentObject(events)
                .environmentObject(tickets)
        }
    }
}
